default:
    just --list

fmt:
    air format R tests

lint:
    jarl check R tests && air format --check R tests

# stage everything and commit, e.g. `just commit feat "add set_axis()"`.
# `type` takes an optional scope: `just commit "fix(axes)" "clamp limits"`
commit type message:
    git add -A && git commit -m '{{ type }}: {{ message }}'

# install the pre-commit and commit-msg hooks from .pre-commit-config.yaml
hooks:
    prek install

test:
    R -q -e "devtools::test()"

document:
    R -q -e "devtools::document()"

readme:
    quarto render README.qmd --to gfm

# install/sync JS deps from package.json + bun.lock
js-install:
    bun install

# rebuild the arcgisChart htmlwidget bundle for development (source maps, unminified)
bundle-dev:
    bun run development

# rebuild the arcgisChart htmlwidget bundle for production (minified) - run before shipping
bundle:
    bun run production

# rebuild on every srcjs/ change (CPU intensive, dev use only)
watch:
    bun run watch
