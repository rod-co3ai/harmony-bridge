# HarmonyBridge - Co-operative Co-Parenting Communication

A Flutter application designed to facilitate harmonious communication between co-parents.

## Features

- Secure messaging between co-parents
- Child profile management
- Scheduling and calendar coordination
- Document sharing and storage
- Expense tracking and management

## Development Setup

### Prerequisites

- Flutter SDK (3.29.1 or later)
- Dart SDK (3.3.0 or later)
- Git
- Android Studio / VS Code with Flutter extensions
- Chrome browser for web development

### Installation

1. Clone the repository:
   ```
   git clone https://github.com/rod-co3ai/harmony-bridge.git
   cd harmony-bridge
   ```

2. Install dependencies:
   ```
   flutter pub get
   ```

3. Run the application:
   ```
   flutter run -d chrome
   ```

## Code Quality Standards

### Zero Tolerance for Deprecated Code

We maintain a strict "zero tolerance" policy for deprecated code in our Flutter projects. This policy helps maintain code quality and reduces technical debt.

#### Key Rules

1. NEVER use deprecated APIs, methods, or functions in new code
2. Always use the latest recommended approaches from official Flutter documentation
3. When encountering deprecated code during development:
   - Immediately update it to modern standards
   - Test thoroughly after updates
   - Document the changes in commit messages

#### Quality Check Command
Before any commit, run this sequence:
```powershell
dart format . ; if ($?) { flutter clean } ; if ($?) { flutter pub get } ; if ($?) { flutter analyze } ; if ($?) { flutter build web --release }
```

#### Common Modernizations
1. Color opacity:
   - ❌ `color.withOpacity(0.5)`
   - ✅ `color.withAlpha((0.5 * 255).round())`

2. Text scaling:
   - ❌ `textScaleFactor: 1.2`
   - ✅ `textScaler: TextScaler.linear(1.2)`

## Deployment

### Web Deployment with Vercel

This project is configured for automatic deployment to Vercel via GitHub Actions.

#### Required Vercel Secrets

Add the following secrets to your GitHub repository:
- `VERCEL_TOKEN`: Your Vercel API token
- `VERCEL_ORG_ID`: Your Vercel organization ID
- `VERCEL_PROJECT_ID`: Your Vercel project ID

#### Deployment Process

1. Push changes to the main branch
2. GitHub Actions will automatically:
   - Build the Flutter web app
   - Deploy to Vercel

### Manual Deployment

To deploy manually to Vercel:

1. Build the web app:
   ```
   flutter build web --release
   ```
   Note: The `--web-renderer canvaskit` flag is no longer needed in Flutter 3.29.1+

2. Deploy using Vercel CLI:
   ```
   cd build/web
   vercel --prod
   ```

### Vercel Configuration

The project uses a `vercel.json` file in the `web` directory to configure routing and caching:

```json
{
  "version": 2,
  "rewrites": [
    { "source": "/(.*)", "destination": "/" }
  ],
  "headers": [
    {
      "source": "/(.*)",
      "headers": [
        { "key": "Cache-Control", "value": "s-maxage=0" }
      ]
    },
    {
      "source": "/(.*).(js|json|css|jpg|jpeg|gif|png|ico|svg)",
      "headers": [
        { "key": "Cache-Control", "value": "public, max-age=31536000, immutable" }
      ]
    }
  ]
}
```

Important: Do not mix legacy `routes` with modern routing properties (`rewrites`, `redirects`, `headers`, etc.) as this will cause deployment failures.

## Supabase Database Management

### Migration Files

All database migrations are stored as `.sql` files with the following format:
`YYYYMMDDHHMMSS_[Service]_[Area]_description.sql`

### Services and Areas

- **Services**: Auth, DB, Storage, Edge
- **Areas**: Table, Func, Trigger, Policy, Column, Schema, Bucket

### Migration Process

1. Test migrations locally with Docker Desktop
2. Apply migrations using Supabase CLI
3. Maintain same migration order in all environments

## Project Structure

```
harmony_bridge/
├── .github/workflows/      # GitHub Actions workflows
├── android/                # Android-specific code
├── assets/                 # Static assets (images, icons)
├── ios/                    # iOS-specific code
├── lib/                    # Dart source code
│   ├── core/               # Core utilities and theme
│   ├── features/           # Feature modules
│   │   ├── auth/           # Authentication
│   │   ├── calendar/       # Calendar functionality
│   │   ├── dashboard/      # Main dashboard
│   │   ├── messaging/      # Messaging system
│   │   ├── profile/        # User profiles
│   │   └── settings/       # App settings
│   ├── shared/             # Shared components
│   │   ├── models/         # Data models
│   │   └── widgets/        # Reusable widgets
│   └── main.dart           # Application entry point
├── test/                   # Test files
└── web/                    # Web-specific files
```

## Recent Changes and Fixes

### March 2025 Updates

1. **Flutter SDK Update**
   - Updated from Flutter 3.10.0 to 3.29.1
   - Fixed deprecated API usage (textScaleFactor → textScaler)
   - Updated color opacity methods (withOpacity → withAlpha)

2. **GitHub Actions Workflow**
   - Updated Flutter version in CI/CD pipeline
   - Removed unsupported web-renderer flag
   - Fixed Vercel deployment configuration

3. **Project Structure**
   - Reorganized repository to avoid nested structure
   - Added missing asset directories
   - Improved code organization

## Troubleshooting

### Common Issues

1. **Vercel Deployment Failures**
   - Check vercel.json for conflicting routing properties
   - Ensure all required secrets are set in GitHub
   - Verify build output in the build/web directory

2. **Flutter Build Errors**
   - Run `flutter doctor` to verify your setup
   - Check for deprecated API usage with `flutter analyze`
   - Update dependencies with `flutter pub upgrade`

3. **Asset Loading Issues**
   - Ensure assets are properly declared in pubspec.yaml
   - Verify asset directories exist (assets/images, assets/icons)
   - Check file paths in code match the asset structure

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
