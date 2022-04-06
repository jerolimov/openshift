# Workaround to fix CORS issues with BitBucket servers

```
caddy run --config Caddyfile --watch
```

Test that it works with:

```
curl -vs https://bitbucket.localhost:22222/rest/api/latest/projects/ODC/repos/nodejs-ex
```

This URL should work then:

https://bitbucket.localhost:22222/projects/ODC/repos/nodejs-ex

URL that should work too - or?

* https://bitbucket.localhost:22222/scm/odc/nodejs-ex.git
* https://bitbucket.localhost:22222/projects/ODC/repos/nodejs-ex/browse  ????

Is there an option that we support this urls as well?

* https://stash.localhost:22223/projects/KGOL/repos/kweb
* https://stash.localhost:22223/scm/kgol/kweb.git

* https://stash.localhost:22223/users/bneumann/repos/kopanocore
* https://stash.localhost:22223/scm/~bneumann/kopanocore.git
