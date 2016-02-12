# stek

Stateful account management and credential caching for scripting Openstack.

### What It Do

- No more copying and pasting auth tokens! stek saves them for you in its
  special folder.
- Auth tokens and service catalogs are cached on your hard drive so you don't
  have to hit Identity on every service call.
- Transparently authenticates you when necessary.
- Allows you to easily switch between any number of accounts.
- Scriptable and hackable! It's like curl but faster. Great for exploring APIs
  from your command line.
- Easy to write plugins for new services.

### Installation

1. First of all, stek requires curl and [jq](https://stedolan.github.io/jq/).
   Make sure you have those before continuing.

2. Get the code and source the loader script into your shell.

    ```
    mkdir ~/.stek
    git clone https://github.com/ksheedlo/stek.git ~/.stek/code
    echo '. $HOME/.stek/code/loader.bash' >>~/.bash_profile
    ```

3. Reload your terminal.

4. Create a user and follow the prompt.

    ```
    $ stek new myuser1
    Username [myuser1]:
    API Key: 1111222233334444
    Tenant ID (optional): 123456
    Auth URL [https://identity.api.rackspacecloud.com/v2.0]:
    ```

5. Set stek to start using the new user.

    ```
    $ stek user myuser1
    ```

6. Start using the included stek plugins and play with APIs!

    ```
    $ ele GET /entities
    {
      "values": [
        {
          "ip_addresses": {},
          "managed": false,
          "agent_id": null,
          "uri": null,
          "updated_at": 0,
          "created_at": 0,
          "metadata": {},
          "id": "enb1bda01b",
          "label": "whut"
        }
      ],
      "metadata": {
        "count": 1,
        "marker": null,
        "next_marker": null,
        "limit": 100,
        "next_href": null
      }
    }
    ```
