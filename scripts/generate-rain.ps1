$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

$width = 900
$height = 96
$frameCount = 48
$frameDelay = 12
$output = Join-Path $PSScriptRoot '..\assets'
[System.IO.Directory]::CreateDirectory($output) | Out-Null
$random = [Random]::new(2411)
$symbols = @('|', ':', "'", ';', '.', '!', ',')
$drops = for ($column = 0; $column -lt 75; $column++) {
    [pscustomobject]@{
        X = 6 + $column * 12
        Y = $random.Next(0, $height)
        Cycles = $random.Next(1, 4)
        Symbol = $symbols[$random.Next($symbols.Count)]
    }
}

function Write-Frame([System.IO.BinaryWriter]$writer, [byte[]]$bytes, [bool]$first) {
    $packed = $bytes[10]
    $paletteSize = 3 * [int][Math]::Pow(2, ($packed -band 7) + 1)
    if (($packed -band 128) -eq 0) { throw 'The GIF encoder did not supply a palette.' }
    if ($first) {
        $writer.Write($bytes, 0, 13 + $paletteSize)
        $writer.Write([byte[]]@(33, 255, 11))
        $writer.Write([Text.Encoding]::ASCII.GetBytes('NETSCAPE2.0'))
        $writer.Write([byte[]]@(3, 1, 0, 0, 0))
    }
    $position = 13 + $paletteSize
    while ($bytes[$position] -eq 33) {
        $position += 2
        while ($bytes[$position] -ne 0) { $position += 1 + $bytes[$position] }
        $position++
    }
    if ($bytes[$position] -ne 44) { throw 'The GIF encoder produced an unexpected image block.' }
    if (($bytes[$position + 9] -band 128) -ne 0) { throw 'An unexpected local palette was supplied.' }
    $descriptor = [byte[]]$bytes[$position..($position + 9)]
    $descriptor[9] = ($descriptor[9] -band 120) -bor 128 -bor ($packed -band 7)
    $writer.Write([byte[]]@(33, 249, 4, 4, $frameDelay, 0, 0, 0))
    $writer.Write($descriptor)
    $writer.Write($bytes, 13, $paletteSize)
    $position += 10
    $start = $position
    $position++
    while ($bytes[$position] -ne 0) { $position += 1 + $bytes[$position] }
    $writer.Write($bytes, $start, $position - $start + 1)
}

$palettes = @{
    light = @('#f8f7f2', '#75836e')
    dark = @('#24231f', '#b0b69d')
}
$font = [System.Drawing.Font]::new('Consolas', 15, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Pixel)
try {
    foreach ($name in @('light', 'dark')) {
        $file = [System.IO.File]::Create((Join-Path $output "rain-$name.gif"))
        $writer = [System.IO.BinaryWriter]::new($file)
        $brush = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml($palettes[$name][1]))
        try {
            for ($frame = 0; $frame -lt $frameCount; $frame++) {
                $bitmap = [System.Drawing.Bitmap]::new($width, $height)
                $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
                $stream = [System.IO.MemoryStream]::new()
                try {
                    $graphics.Clear([System.Drawing.ColorTranslator]::FromHtml($palettes[$name][0]))
                    $graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::SingleBitPerPixelGridFit
                    foreach ($drop in $drops) {
                        $y = ($drop.Y + $height * $drop.Cycles * $frame / $frameCount) % $height
                        foreach ($offset in @(-$height, 0)) {
                            $graphics.DrawString($drop.Symbol, $font, $brush, [single]$drop.X, [single]($y + $offset))
                        }
                    }
                    if ($frame -eq 0) { $bitmap.Save((Join-Path $output "rain-$name.png"), [System.Drawing.Imaging.ImageFormat]::Png) }
                    $indexed = $bitmap.Clone([System.Drawing.Rectangle]::new(0, 0, $width, $height), [System.Drawing.Imaging.PixelFormat]::Format1bppIndexed)
                    try {
                        $palette = $indexed.Palette
                        $palette.Entries[0] = [System.Drawing.ColorTranslator]::FromHtml($palettes[$name][$(if ($name -eq 'dark') { 0 } else { 1 })])
                        $palette.Entries[1] = [System.Drawing.ColorTranslator]::FromHtml($palettes[$name][$(if ($name -eq 'dark') { 1 } else { 0 })])
                        $indexed.Palette = $palette
                        $indexed.Save($stream, [System.Drawing.Imaging.ImageFormat]::Gif)
                    } finally { $indexed.Dispose() }
                    Write-Frame $writer $stream.ToArray() ($frame -eq 0)
                } finally {
                    $stream.Dispose()
                    $graphics.Dispose()
                    $bitmap.Dispose()
                }
            }
            $writer.Write([byte]59)
        } finally {
            $brush.Dispose()
            $writer.Dispose()
        }
    }
} finally { $font.Dispose() }

Get-ChildItem -LiteralPath $output -File | Select-Object Name, Length
