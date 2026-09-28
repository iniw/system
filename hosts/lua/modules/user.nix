{
  systemModule = { user, ... }: {
    users = {
      users.${user} = {
        description = "Vinicius Deolindo";

        hashedPassword = "$6$EdcjgcyNsYTBw6HG$KMDjV0ZVjVXxYbT8ketYJ2qkCwYIqzQWo5JKP9TxEE.qV0/u8ag6MyiVOsOLM1R6cjCbeYeTa.muyH3lK8G9v/";

        isNormalUser = true;
      };

      mutableUsers = false;
    };

    services.userborn.enable = true;
  };
}
