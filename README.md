# NYU Hackathon Project
This guide will walk you through setting up the required environment to run the Flutter project, from installing Visual Studio to running the project. The executable `FAP.exe` is already built and located in the repository.

## Prerequisites

Before running the Flutter project, ensure you have the following installed on your machine:

- **Visual Studio** (for building Windows applications with Flutter)
- **Flutter SDK**
- **Git** (for cloning the repository)
- **Windows OS** (this guide is for Windows)

### Step 1: Install Visual Studio

Visual Studio is required for Flutter to build and run Windows applications.

1. **Download Visual Studio**:
   - Go to [Visual Studio Downloads](https://visualstudio.microsoft.com/downloads/).
   - Select **Visual Studio 2022** (or a later version) and download the **Community Edition** (free version).

2. **Install Visual Studio**:
   - During installation, select the following workloads:
     - **Desktop development with C++**
     - **Universal Windows Platform (UWP) development** (optional but recommended)

3. **Launch Visual Studio**:
   - After installation, open Visual Studio and ensure that it’s updated to the latest version.

### Step 2: Install Git

Git is required to clone the Flutter project repository.

1. **Download Git**:
   - Go to [Git Downloads](https://git-scm.com/downloads).
   - Download and install Git for Windows.

2. **Verify Git installation**:
   - Open Command Prompt or PowerShell and run the following command:
     ```bash
     git --version
     ```
   - Ensure Git is properly installed (you should see the version number).

### Step 3: Install Flutter SDK

Flutter is the framework used for the project, and the SDK is required to manage dependencies and run the project.

1. **Download Flutter SDK**:
   - Visit the [Flutter installation page](https://flutter.dev/docs/get-started/install).
   - Download the latest stable release for **Windows**.

2. **Extract Flutter SDK**:
   - After downloading the zip file, extract it to a desired location, such as `C:\flutter`.

3. **Add Flutter to PATH**:
   - Open the **Start menu**, search for "Environment Variables", and select **Edit the system environment variables**.
   - Under **System Properties**, click **Environment Variables**.
   - In the **System variables** section, find and select the **Path** variable, then click **Edit**.
   - Click **New** and add the path to the Flutter SDK’s `bin` directory. For example:
     ```bash
     C:\flutter\bin
     ```

4. **Verify Flutter installation**:
   - Open Command Prompt or PowerShell and run the following command:
     ```bash
     flutter doctor
     ```
   - Flutter will check your environment and display any missing dependencies. Follow the instructions to install any missing components.

### Step 4: Clone the Flutter Repository

Now, clone the Flutter project repository to your local machine.

1. **Clone the repository**:
   - Open Command Prompt or PowerShell and navigate to the directory where you want to store the project.
   - Run the following command to clone the repository:
     ```bash
     git clone https://github.com/your-username/job-tracking-system.git
     ```
   - Replace `your-username` with the actual username if necessary.

2. **Navigate to the project directory**:
   ```bash
   cd job-tracking-system

### Step 5: Install Flutter Dependencies

After cloning the repository, you need to install the required dependencies.

**Get dependencies**:
In the project directory, run the following command:
```bash
flutter clean && flutter build windows
```
This will clean and build the .exe file.


# EXE FILE: The .exe file is located in `build\windows\x64\runner\Release\FAP.exe`


