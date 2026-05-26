# Examples

Status: Public guide

The private code repository includes small examples under `examples/`. They are
intended as integration references for PALM Jia users who have access to the
code repository.

## Smoke Script

`examples/smokeExpManner.m`

Runs a minimal end-to-end workflow:

- Adds the project root and examples folder to the MATLAB path.
- Loads `Dataset("Iris", Normalize="range")`.
- Runs the demo k-means model.
- Runs a simple NMF-style model.
- Runs a lightweight LRDSC-style NMF adapter.
- Records local results under a `results/smoke` folder.

Use this script after installation to confirm that datasets, models, metrics,
recording, and loading are wired together.

```matlab
run("examples/smokeExpManner.m")
```

## Demo Models

| Example | Purpose |
| --- | --- |
| `examples/+DemoModels/KMeans.m` | Minimal duck-typed model that returns `ModelStats` directly |
| `examples/+DemoModels/CompactKMeans.m` | Equivalent k-means style wrapper using `ModelBase` |
| `examples/+DemoModels/SimpleNMF.m` | Minimal NMF-style model returning membership predictions |
| `examples/+LRDSCAdapters/BasicNMF.m` | Adapter pattern for LRDSC-style factorization code |

## What to Copy

Use the examples as templates for interface shape, not as benchmark baselines.

For a label-returning algorithm, start from the k-means style pattern:

```matlab
function fields = requiredInitFields(~)
    fields = "labels";
end
```

For a factorization algorithm, start from the NMF-style pattern:

```matlab
function fields = requiredInitFields(~)
    fields = ["factors.U", "factors.V"];
end
```

For new wrappers, prefer the compact `ModelBase` form when it fits your model.
Use a full duck-typed class when you need complete control over the `ModelStats`
object.

## Result Artifacts

Example runs may create local artifacts under `results/`. These folders are not
documentation assets and should not be committed. Result files can include
dataset names, options, metrics, and model-specific outputs.

## Public-Safe Usage

When adapting examples for public tutorials:

- Use placeholder paths such as `<path-to-ExpManner>`.
- Use small public datasets such as `Iris` when possible.
- Avoid publishing internal result folders.
- Avoid copying private algorithm implementations into the public docs site.
