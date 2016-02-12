# stek

Stateful account management and credential caching for scripting Openstack.

### What It Do

- No more copying and pasting auth tokens! stek saves them for you in its special folder.
- Auth tokens and service catalogs are cached on your hard drive so you don't have to hit
  Identity on every service call.
- Transparently authenticates you when necessary.
- Allows you to easily switch between any number of accounts.
- Scriptable and hackable! It's like curl but faster. Great for exploring APIs from your
  command line.
- Easy to write plugins for new services.
