import * as dotenv from "dotenv";
dotenv.config();

import {
  SignUpCommand,
  CognitoIdentityProviderClient,
} from "@aws-sdk/client-cognito-identity-provider";

const cognitoClient = new CognitoIdentityProviderClient({
  region: "us-east-1",
});

async function register() {
  const params = {
    ClientId: process.env.COGNITO_CLIENT_ID,
    Username: "fraol",
    Password: "password",
    UserAttributes: [
      {
        Name: "email",
        Value: "fraol0912@gmail.com",
      },
    ],
  };

  const command = new SignUpCommand(params);
  try {
    const data = await cognitoClient.send(command);
    console.log("User registered:", data);
  } catch (err) {
    console.log("Error", err);
  }
}

register();
