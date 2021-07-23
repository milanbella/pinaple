let app = ResKoa.Koa.newKoa();

let koaBody = ResKoa.Body.koaBody()

ResKoa.Koa.use(app, koaBody)
ResKoa.Koa.use(app, ResKoa.Router.routes(Routes.router))
ResKoa.Koa.use(app, ResKoa.Router.allowedMethods(Routes.router))

