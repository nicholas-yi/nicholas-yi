# Nicholas Yi

I build evaluation infrastructure and machine-learning research tools.
I'm interested in making model behavior measurable, reproducible, and easier
to inspect.

## Current open-source work

### Staccato: offline speech-transcript evaluation

A new contribution to the evaluation tooling around
[Microsoft's Staccato speech-recognition pipeline](https://github.com/microsoft/Staccato-Stuttered-ASR):

- CPU-only comparison of saved baseline and refined transcripts.
- Explicit intended-message versus verbatim reference contracts.
- Corpus word error rate, per-example regressions, and paired latency/cost coverage.
- Strict input validation, 33 regression tests, and passing Linux/Windows CI.

[Contribution PR #29](https://github.com/microsoft/Staccato-Stuttered-ASR/pull/29)
is open for upstream review.
[Code and usage](https://github.com/nicholas-yi/Staccato-Stuttered-ASR/blob/main/docs/offline-evaluation.md)
| [CI](https://github.com/nicholas-yi/Staccato-Stuttered-ASR/actions/runs/41087232339)

The included examples are synthetic tests, not model-performance claims.
The existing Staccato architecture remains credited to its original authors.

## Competition results

| Competition | Historical result | Public record |
|---|---|---|
| Hateful Memes Challenge: Phase 2 (2020) | 18th place, as `nickyi` | [DrivenData leaderboard](https://www.drivendata.org/competitions/70/hateful-memes-phase-2/leaderboard/#leaderRow_151286) |
| Kuzushiji Recognition (2019) | 17th of 293 teams, as `nicholasyi` | [Kaggle competition profile](https://www.kaggle.com/nicholasyi/competitions) |

[Competition record and reproduction notes](notes/competition-record.md)
separate those historical results from other authors' reference implementations
and any future reproduction work.
