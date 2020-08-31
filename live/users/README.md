## How are we managing IAM here?
We have decoupled the definition of roles (with IAM permissions) and groups/users (who only have permissions to assume roles). This does two things:
1) This enforces a pattern of permission-by-role.
2) This follows the same pattern necessary for cross-account architectures. Those may not always be needed, but I think it is not a bad idea to standardize in an extensible fashion.

## Diagram
<code>
+--> AWS Account
|   |----------------------------------------|
|   |  Group                                 |
|   |  |------------|                        |
|   |  |   User(s)  | ----> IAM Policy       |
|   |  |____________|           |            |
|   |                    (Permission to      |
|   |                     assume roles)      |
|   |                           |            |
|   |                           |            |
|   |___________________________|____________|
|                               |
+--> AWS Account                |
|   |---------------------------|------------|
|   |                           V            |
|   |                      IAM Role          |
|   |                     /     |            |
+----- Assume Role Policy       |            |
    |                       IAM Policy       |
    |                           |            |
    |                           V            |
    |                       (Do stuff)       |
    |________________________________________|
</code>
This diagram illustrates the IAM model.

In the first (user) account:
 - User(s) are members of group(s), and have no other IAM (permission) config.
 - Groups each get an IAM policy that only gives Assume Role permissions.
 - Permissions can be for any combination of IAM Roles in any account.

In the second (role) account (which can be any account -- it could be the same account):
 - IAM Roles are created.
 - IAM Roles use an Assume Role policy enabling any desired account root as principal.
 - IAM Roles attach IAM Policies giving whatever fine-grained permissions are desired.
