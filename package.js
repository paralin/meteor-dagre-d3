Package.describe({
  summary: "A d3 renderer for the dagre layout engine."
});

Package.on_use(function (api, where) {
  api.use('coffeescript');
  api.use('d3');
  api.add_files(['dagre-d3.js', 'ReactiveRender.coffee'], ['client']);
  api.export('ReactiveDagre');
});
