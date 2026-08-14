default:
    just --list

fmt:
    air format R/* tests/*

lint:
    jarl check R/* tests/testthat/* && air format --check R/* tests/*

test:
    R -q -e "devtools::test()"

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
