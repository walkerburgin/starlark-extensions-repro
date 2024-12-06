aspect.register_rule_kind("postcss", {
    "From": "//bazel:defs.bzl",
    "NonEmptyAttrs": ["postcss_config", "srcs"],
    "MergeableAttrs": ["srcs"],
})

def prepare(_):
    return aspect.PrepareResult(
        sources = [
            aspect.SourceFiles("postcss.config.mjs"),
            aspect.SourceExtensions(".css"),
        ],
        queries = {
            "imports": aspect.AstQuery(
                filter = "postcss.config.mjs",
                query = "(import_statement (import_clause) (string (string_fragment) @import))",
            )
        }
    )

def declare(ctx):
    postcss_config = None
    srcs = []
    for source in ctx.sources:
        if source.path == "postcss.config.mjs":
            postcss_config = source
        elif source.path.endswith(".css"):
            srcs.append(source)
        else:
            fail()

    if not postcss_config:
        ctx.targets.remove("postcss")
        return

    postcss_config_deps = [imprt.captures["import"] for imprt in postcss_config.query_results["imports"]]

    ctx.targets.add(
        name = "postcss",
        kind = "postcss",
        attrs = {
            "postcss_config": postcss_config.path,
            "srcs": [s.path for s in srcs],
            "deps": [aspect.Import(id = dep, provider = "js", src = postcss_config.path) for dep in postcss_config_deps]
        }
    )

aspect.register_configure_extension(
    id = "postcss",
    prepare = prepare,
    declare = declare,
)
