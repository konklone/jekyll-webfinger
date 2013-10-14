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

This will create a URL at `/.well-known/webfinger` that returns:

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

### MIT License

This project is published [under the MIT License](LICENSE).