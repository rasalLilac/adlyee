flutter clean
flutter build apk --release -t lib/main.dart --tree-shake-icons
flutter build apk --split-per-abi --target lib/main.dart --tree-shake-icons
