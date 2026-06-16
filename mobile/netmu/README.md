# Netmu

## Device

- Use Android device that support Android API 35+

## Setup

### Environment

Create an `.env` in the root directory. Set

```bash
API_BASE=http://10.0.2.2/5001/api
```

> NOTE: If you are running the project on an emulator, the API must be `10.0.2.2`, since localhost
> will point the device itself.

### Firebase

> NOTE: to use Firebase, it's better to run this project on an emulator

- First, create a Firebase project by click to `Go to console`.
- After creating Firebase project, go to **Settings** > **General** > **Service accounts**. Generate
a new private key. It will install a json file to your machine. Place that file in the root directory
in the **backend** project. 
- Install Firebase CLI and flutter fire CLI:

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Install flutter fire
dart pub global activate flutterfire_cli

# Login to your firebase
firebase login

# Verify your setups by listing current projects
firebase projects:list

# Navigate to your **mobile** project root directory and run
flutterfire configure --project=<YOUR_PROJECT_ID>

# Confirm that a lib/firebase_options.dart was generated
```