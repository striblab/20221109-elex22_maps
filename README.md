# Elections 2022 precinct map generator

An automagical generator of Mapbox embeds for 2022 Minnesota midterm precinct-level electoral results.

## Dataviz generation

Instructions for reporters, graphic designers and anyone else:

1. [Launch the map configuration page](https://striblab.github.io/20221109-elex22_maps/public/form/config.html) hosted from public/form/config.html

2. Select map configuration options

3. Click GENERATE and an embeddable Mapbox URL will pop into a new browser.

4. Download necessary GEOJSON shapefiles, result CSVs and SVGs for desired contests and geographies from the list below the configuration option.


## Source data compilation

Macbook instructions for local data ingestion of new precinct-level and county-level results:

1. Open Terminal

2. Make the desired bash scripts executable (using the story/data/download/governor folder as an example)

```bash
sudo chmod +x <LOCALPATH>/20221109-elex22maps/story/data/download/governor/make_gov_maps.sh
sudo chmod +x <LOCALPATH>/20221109-elex22maps/story/data/download/governor/make_gov_counties.sh
```

3. This will produce bound GEOJSON shapefiles, results CSVs and SVG maps for the gubernatorial contest on both precinct and county levels.

4. Move gov-counties.json, gov-results-geo.json, gov-counties.svg, gov.svg, gov-counties.csv and gov.csv to the public/data folder

5. Deploy the project to AWS S3 instance as normal


## About the workflow

This is a project template for [Svelte](https://svelte.dev) apps. It lives at https://github.com/striblab/svelte3-template-webpack and is a fork of https://github.com/sveltejs/template-webpack.

To create a new project based on this template using [degit](https://github.com/Rich-Harris/degit):

```bash
npx degit striblab/svelte3-template-webpack svelte-app
cd svelte-app
```

*Note that you will need to have [Node.js](https://nodejs.org) installed.*


## Get started

Install the dependencies...

```bash
cd svelte-app
npm install
```

...then start webpack:

```bash
npm run dev
```

Navigate to [localhost:8080](http://localhost:8080). You should see your app running. Edit a component file in `src`, save it, and the page should reload with your changes.


## Deploying to the web

```bash
npm run deploy
```

Or, some other suggestions from Rich Harris:

### With [now](https://zeit.co/now)

Install `now` if you haven't already:

```bash
npm install -g now
```

Then, from within your project folder:

```bash
now
```

As an alternative, use the [Now desktop client](https://zeit.co/download) and simply drag the unzipped project folder to the taskbar icon.

### With [surge](https://surge.sh/)

Install `surge` if you haven't already:

```bash
npm install -g surge
```

Then, from within your project folder:

```bash
npm run build
surge public
```
