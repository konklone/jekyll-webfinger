### A Jekyll plugin for Webfinger.

An easy Jekyll plugin for adding Webfinger support to your domain.

**Note**: This won't work Github Pages, which doesn't allow plugins. Use this only with a Jekyll site you're generating yourself.

### What is Webfinger?

It's a way to attach information to your email address.

Take an email address, and ask its domain about it using HTTPS. For example, information about `eric@konklone.com` is available in JSON at:

```
https://konklone.com/.well-known/webfinger?resource=acct:eric@konklone.com
```

See [webfinger.net](http://webfinger.net), [Paul E. Jones' description](http://www.packetizer.com/webfinger/), or Webfinger's official standard at [RFC 7033](http://tools.ietf.org/html/rfc7033) for more information.

### Using jekyll-webfinger

Create a `_plugins` folder in your project if it doesn't exist, and place `webfinger_generator.rb` into it.

Then, create a `_webfinger.yml` in the root of your project, that looks something like this:

```yaml
eric@konklone.com:
  name: Eric Mill
  website: https://konklone.com
```

When your Jekyll site is built, it will create a URL at `/.well-known/webfinger` that returns:

```json
{
  "subject": "eric@konklone.com",
  "properties": {
    "http://schema.org/name": "Eric Mill"
  },
  "links": [
    {
      "rel": "http://webfinger.net/rel/profile-page",
      "href": "https://konklone.com"
    }
  ]
}
```

The response will actually be compact (not indented, like the above example).

### Caveats

* Webfinger **requires HTTPS**. If you set this up on a non-secure website (`http://`), be prepared for most Webfinger clients to not find your data.
* Since this is static file hosting, the query string is being ignored. So **all Webfinger requests will return the same data**. This in violation of the spec, but I'm not aware of how else to implement Webfinger using static files.
* It's on you to configure your web server to set the `Content-Type` to `application/jrd+json` for `/.well-known/webfinger`. If you don't, it will probably be set et `application/octet-stream`, which is in violation of the spec (though most clients will probably still parse it fine).

### MIT License

This project is published [under the MIT License](LICENSE).