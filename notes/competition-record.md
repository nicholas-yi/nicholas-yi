# Competition record and reproduction notes

Reviewed October 30, 2026. Historical leaderboard entries are separate from new
code, reproductions, or experiments.

## Historical results

- **Hateful Memes Challenge: Phase 2 (2020): 18th place, `nickyi`.**
  [Official leaderboard](https://www.drivendata.org/competitions/70/hateful-memes-phase-2/leaderboard/#leaderRow_151286).
- **Kuzushiji Recognition (2019): 17th of 293 teams, `nicholasyi`.**
  [Public competitor profile](https://www.kaggle.com/nicholasyi/competitions)
  and [competition leaderboard](https://www.kaggle.com/competitions/kuzushiji-recognition/leaderboard).

These records establish placement. They do not independently establish a model
architecture or the provenance of any particular implementation. Original
submission artifacts are not included here. Other competitors' implementations
must not be presented as the code behind these results.

## External implementations reviewed

### Hateful Memes

- [Official winning-solutions index](https://github.com/drivendataorg/hateful-memes).
- [Official community forum](https://community.drivendata.org/c/hateful-memes/34)
  and [top-five solution discussion](https://community.drivendata.org/t/top-5-winning-solutions-paper-code/5707).
- [Vilio](https://github.com/Muennighoff/vilio), by Niklas Muennighoff, is the
  second-place implementation listed by the organizers.
  Its [reproduction guide](https://github.com/Muennighoff/vilio/blob/master/SCORE_REPRO.md)
  documents separate feature-extraction and model environments, including
  conflicting dependencies. The repository has an
  [MIT license](https://github.com/Muennighoff/vilio/blob/master/LICENSE);
  imported subprojects, weights, and data need their own checks.

**A bounded new experiment, not yet run:** compare text-only, image-only, and
multimodal baselines on a fixed, authorized validation split, then measure OCR
perturbation sensitivity. Report AUROC, false-positive behavior, and inference
cost with clearly stated split provenance. Do not select thresholds on the final
test set or claim an old leaderboard placement for the new implementation.

### Kuzushiji Recognition

- [Competition discussions](https://www.kaggle.com/competitions/kuzushiji-recognition/discussion).
- Konstantin Lopukhin's
  [second-place discussion](https://www.kaggle.com/competitions/kuzushiji-recognition/discussion/112712)
  and [implementation](https://github.com/lopuhin/kaggle-kuzushiji-2019)
  describe character detection followed by context-aware classification.
  The code has an
  [MIT license](https://github.com/lopuhin/kaggle-kuzushiji-2019/blob/master/LICENSE).
- The implementation documents a Python 3.6-era environment, book-grouped folds,
  out-of-fold detector outputs, and pseudolabeling. Those choices matter more to
  a faithful reproduction than simply updating dependency versions.

**A bounded new experiment, not yet run:** hold detector outputs fixed and compare
single-character crops with larger contextual crops. Keep validation books
separate from training books, report the competition's detection/classification
metric, and label any use of test-set pseudolabels as transductive. Do not infer
that this second-place approach was the architecture of my seventeenth-place
entry.

## Publication standard

Any future reproduction should identify the exact upstream revision, retain
applicable notices, record its environment, document authorized data access,
and distinguish reproduced scores from published scores. A fork alone is not
evidence that a reproduction succeeded.
