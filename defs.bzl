def _my_rule_impl(ctx):
    ctx.actions.write(ctx.outputs.out, ctx.attr.content)
    return [DefaultInfo(files = depset([ctx.outputs.out]))]

my_rule = rule(
    _my_rule_impl,
    attrs = {
        "content": attr.string(),
        "out": attr.output(),
    },
)

MyProvider = provider(fields = ["content"])

def _my_aspect_impl(target, ctx):
    if ctx.rule.kind != "my_rule":
        return []

    info = MyProvider(content = ctx.rule.attr.content)
    print("ASPECT", info)
    return [info]

my_aspect = aspect(_my_aspect_impl)
