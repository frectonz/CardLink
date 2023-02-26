import * as dotenv from "dotenv";
dotenv.config();

import {
  SignUpCommand,
  InitiateAuthCommand,
  ConfirmSignUpCommand,
  CognitoIdentityProviderClient,
} from "@aws-sdk/client-cognito-identity-provider";
import { createInterface } from "node:readline/promises";
import { stdin as input, stdout as output } from "node:process";

const rl = createInterface({ input, output });

const cognitoClient = new CognitoIdentityProviderClient({
  region: "us-east-1",
});

async function register(username: string, password: string, email: string) {
  const command = new SignUpCommand({
    ClientId: process.env.COGNITO_CLIENT_ID,
    Username: username,
    Password: password,
    UserAttributes: [
      {
        Name: "email",
        Value: email,
      },
    ],
  });

  try {
    const data = await cognitoClient.send(command);
    console.log("User registered:", data);
  } catch (err) {
    console.log("Registration Error", err);
    return;
  }

  const code = await rl.question("Enter code: ");
  const confirmCommand = new ConfirmSignUpCommand({
    ClientId: process.env.COGNITO_CLIENT_ID,
    ConfirmationCode: code,
    Username: username,
  });

  try {
    const confirmData = await cognitoClient.send(confirmCommand);
    console.log("User confirmed:", confirmData);
  } catch (err) {
    console.log("Confirmation Error", err);
  }
}

async function login(username: string, password: string) {
  const command = new InitiateAuthCommand({
    AuthFlow: "USER_PASSWORD_AUTH",
    ClientId: process.env.COGNITO_CLIENT_ID,
    AuthParameters: {
      USERNAME: username,
      PASSWORD: password,
    },
  });
  try {
    const data = await cognitoClient.send(command);
    console.log("User logged in:", data);
    return data.AuthenticationResult;
  } catch (err) {
    console.error("Login Error", err);
  }
}

async function main() {
  // const token = await register("fraol", "password", "fraol0912@gmail.com").then(
  //   () => login("fraol", "password")
  // );
  const token = await login("fraol", "password");

  if (!token) {
    console.error("No token");
    process.exit(1);
  }

  const createLinkReq = await fetch(
    `https://${process.env.API_GATEWAY_ID}.execute-api.us-east-1.amazonaws.com/prod/link`,
    {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token.AccessToken}`,
      },
      body: JSON.stringify({}),
    }
  );

  const createLinkRes = await createLinkReq.text();

  console.log("Create Link", createLinkRes);

  process.exit(0);
}

main();
