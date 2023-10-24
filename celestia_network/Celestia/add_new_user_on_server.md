## Create a new user account on the dedicated server

If you are signed in as the root user, you can create a new user at any time by running the following:

```
adduser <USER_NAME>

```

Grant the user sudo privileges

```
usermod -aG sudo <USER_NAME>

```

Check if the new user has sudo as one of the groups

```
groups <USER_NAME>
```

