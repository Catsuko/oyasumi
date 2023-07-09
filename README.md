# Oyasumi

A JSON API to help you sleep better!

## Dependencies:

- **PostgreSQL** >= 14.1
- **Ruby** 3.2.2

## Running with Docker

Use `docker-compose` to run:

```shell
cd oyasumi
docker-compose up -d
```

If running for the first time, create the databases:

```shell
docker exec oyasumi_app_1 rails db:setup
```

Then go wild: http://localhost:3000/

### Running the tests

Check out the tests if you want an overview of what the app can do:

```shell
docker exec oyasumi_app_1 rspec -fd
```

## Resources

### Sleeps

<details>
 <summary><code>GET</code> <code><b>/users/:user_id/sleeps</b></code> ⇌ list sleeps for the user</summary>

##### Parameters

> | name      |  type     | data type               | location  | description                                                    |
> |-----------|-----------|-------------------------|-----------|----------------------------------------------------------------|
> | user_id   |  required | integer                 | path      | id of the owner of the sleeps                                  |
> | number    |  optional | integer                 | query     | default and maximum is 50                                      |
> | from      |  optional | string                  | query     | ISO8601 datetime format; use previous `started_at` to paginate |

</details>

<details>
 <summary><code>POST</code> <code><b>/users/:user_id/sleeps</b></code> ⇌ record sleep for the user</summary>

##### Parameters

> | name               |  type     | data type               | location  | description                                                    |
> |--------------------|-----------|-------------------------|-----------|----------------------------------------------------------------|
> | user_id            |  required | integer                 | path      | id of the owner of the sleep                                   |
> | sleep[started_at]  |  required | string                  | body      | ISO8601 datetime format; start date and time of the sleep      |
> | sleep[ended_at]    |  optional | string                  | body      | ISO8601 datetime format; end date and time of the sleep        |

</details>

<details>
 <summary><code>PUT</code> <code><b>/users/:user_id/sleeps</b></code> ⇌ update sleep details for the user</summary>

##### Parameters

> | name               |  type     | data type               | location  | description                                                    |
> |--------------------|-----------|-------------------------|-----------|----------------------------------------------------------------|
> | user_id            |  required | integer                 | path      | id of the owner of the sleep                                   |
> | sleep[started_at]  |  optional | string                  | body      | ISO8601 datetime format; start date and time of the sleep      |
> | sleep[ended_at]    |  optional | string                  | body      | ISO8601 datetime format; end date and time of the sleep        |

</details>

### Follows

<details>
 <summary><code>POST</code> <code><b>/users/:user_id/follows</b></code> ⇌ follow another user</summary>

##### Parameters

> | name               |  type     | data type               | location  | description                                                    |
> |--------------------|-----------|-------------------------|-----------|----------------------------------------------------------------|
> | user_id            |  required | integer                 | path      | id of the owner of the sleep                                   |
> | followed_user_id   |  required | integer                 | body      | id of the user to follow                                       |

</details>

<details>
 <summary><code>DELETE</code> <code><b>/users/:user_id/follows/:followed_user_id</b></code> ⇌ unfollow a user</summary>

##### Parameters

> | name               |  type     | data type               | location  | description                                                    |
> |--------------------|-----------|-------------------------|-----------|----------------------------------------------------------------|
> | user_id            |  required | integer                 | path      | id of the owner of the sleep                                   |
> | followed_user_id   |  required | integer                 | path      | id of the user to unfollow                                     |

</details>

### Following Sleeps

<details>
 <summary><code>GET</code> <code><b>/users/:user_id/following_sleeps</b></code> ⇌ lists the longest sleeps from a user's following users in a week</summary>

##### Parameters

> | name      |  type     | data type               | location  | description                                                    |
> |-----------|-----------|-------------------------|-----------|----------------------------------------------------------------|
> | user_id   |  required | integer                 | path      | id of the owner of the sleeps                                  |
> | number    |  optional | integer                 | query     | default and maximum is 50                                      |
> | week      |  optional | string                  | query     | ISO8601 datetime format; defaults to the current week          |

</details>

### Mock Data

The database will be seeded with some mock users to play around with. Given a fresh database, you can use `user_id` from `1-10` to experiment with the endpoints.
