#!/bin/bash

# Development script for 2do Health Reminders Flutter app

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_color() {
    printf "${1}${2}${NC}\n"
}

# Function to check if Flutter is installed
check_flutter() {
    if ! command -v flutter &> /dev/null; then
        print_color $RED "Flutter is not installed or not in PATH"
        print_color $YELLOW "Please install Flutter from https://flutter.dev/docs/get-started/install"
        exit 1
    fi
    
    print_color $GREEN "Flutter found: $(flutter --version | head -n 1)"
}

# Function to setup the project
setup() {
    print_color $BLUE "Setting up 2do Health Reminders project..."
    
    # Get Flutter dependencies
    print_color $YELLOW "Getting Flutter dependencies..."
    flutter pub get
    
    # Generate code
    if command -v dart &> /dev/null; then
        print_color $YELLOW "Generating code..."
        dart run build_runner build --delete-conflicting-outputs
    fi
    
    print_color $GREEN "Setup complete!"
}

# Function to run the app
run() {
    local device=${1:-chrome}
    print_color $BLUE "Running app on $device..."
    flutter run -d $device
}

# Function to build the app
build() {
    local platform=${1:-web}
    
    case $platform in
        web)
            print_color $BLUE "Building for web..."
            flutter build web --release
            print_color $GREEN "Web build complete! Check build/web/"
            ;;
        android)
            print_color $BLUE "Building for Android..."
            flutter build apk --release
            flutter build appbundle --release
            print_color $GREEN "Android build complete! Check build/app/outputs/"
            ;;
        ios)
            print_color $BLUE "Building for iOS..."
            flutter build ios --release
            print_color $GREEN "iOS build complete! Open ios/Runner.xcworkspace in Xcode"
            ;;
        all)
            print_color $BLUE "Building for all platforms..."
            flutter build web --release
            flutter build apk --release
            flutter build appbundle --release
            if [[ "$OSTYPE" == "darwin"* ]]; then
                flutter build ios --release
            fi
            print_color $GREEN "All builds complete!"
            ;;
        *)
            print_color $RED "Unknown platform: $platform"
            print_color $YELLOW "Available platforms: web, android, ios, all"
            exit 1
            ;;
    esac
}

# Function to run tests
test() {
    print_color $BLUE "Running tests..."
    flutter test
    print_color $GREEN "Tests complete!"
}

# Function to analyze code
analyze() {
    print_color $BLUE "Analyzing code..."
    flutter analyze
    print_color $GREEN "Analysis complete!"
}

# Function to format code
format() {
    print_color $BLUE "Formatting code..."
    dart format lib/ test/
    print_color $GREEN "Code formatted!"
}

# Function to clean the project
clean() {
    print_color $BLUE "Cleaning project..."
    flutter clean
    flutter pub get
    print_color $GREEN "Project cleaned!"
}

# Function to show help
help() {
    print_color $BLUE "2do Health Reminders Development Script"
    echo ""
    print_color $YELLOW "Usage: $0 [command] [options]"
    echo ""
    print_color $GREEN "Commands:"
    echo "  setup              Setup the project (install dependencies, generate code)"
    echo "  run [device]       Run the app (default: chrome)"
    echo "  build [platform]   Build the app (web, android, ios, all)"
    echo "  test               Run tests"
    echo "  analyze            Analyze code"
    echo "  format             Format code"
    echo "  clean              Clean project"
    echo "  help               Show this help message"
    echo ""
    print_color $YELLOW "Examples:"
    echo "  $0 setup"
    echo "  $0 run"
    echo "  $0 run android"
    echo "  $0 build web"
    echo "  $0 build all"
    echo "  $0 test"
}

# Main script logic
main() {
    check_flutter
    
    case ${1:-help} in
        setup)
            setup
            ;;
        run)
            run $2
            ;;
        build)
            build $2
            ;;
        test)
            test
            ;;
        analyze)
            analyze
            ;;
        format)
            format
            ;;
        clean)
            clean
            ;;
        help|--help|-h)
            help
            ;;
        *)
            print_color $RED "Unknown command: $1"
            help
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"