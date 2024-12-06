def postcss(name, srcs = [], postcss_config = None):
    outs = []
    for (idx, src) in enumerate(srcs):
        out = src.replace(".css", ".css.ts")
        outs.append(out)
        native.genrule(
            name = "_{name}_{idx}".format(name = name, idx = idx),
            srcs = [src],
            outs = [out],
            cmd = """sed -nE 's/^\\.([a-zA-Z0-9_\\-]+).*$$/export const \\1 = "\\1";/p' $< > $@""",
        )
    
    native.filegroup(name = name, srcs = outs)