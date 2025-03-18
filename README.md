# Co3 - Co-operative Co-Parenting Communication

A Flutter application designed to facilitate harmonious communication between co-parents.

## Features

- Secure messaging between co-parents
- Child profile management
- Scheduling and calendar coordination
- Document sharing and storage
- Expense tracking and management

## Development Setup

### Prerequisites

- Flutter SDK (3.19.0 or later)
- Dart SDK (3.3.0 or later)
- Git
- Android Studio / VS Code with Flutter extensions
- Chrome browser for web development

### Installation

1. Clone the repository:
   ```
   git clone https://github.com/your-username/co3-app.git
   cd co3-app
   ```

2. Install dependencies:
   ```
   flutter pub get
   ```

3. Run the application:
   ```
   flutter run -d chrome
   ```

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
   flutter build web --release --web-renderer canvaskit
   ```

2. Deploy using Vercel CLI:
   ```
   cd build/web
   vercel --prod
   ```

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

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
