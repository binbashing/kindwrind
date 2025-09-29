## Automated Updates
- **Daily**: Checks for Kind releases and Docker base image updates
- **Kind Updates**: Creates PR for manual review  
- **Docker Updates**: Automatically tests and rebuilds if base image is newer
- **Main Branch**: Push/merge to main triggers tests → build if tests pass
- **PR Testing**: Runs tests on pull requests without building images
```mermaid
flowchart TD
    A["Daily Check (6AM UTC)"] --> B{"Updates Found?"}
    
    B -->|"Kind Version"| C["Create PR"]
    B -->|"Docker DinD"| D["Run Tests"]
    B -->|"None"| E["Keepalive"]
    
    D --> F["Integration Tests"]
    F -->|"Pass"| G["Build & Push"]
    F -->|"Fail"| H["Stop"]
    
    I["PR Activity"] --> J["Integration Tests"]
    K["Push/Merge to Main"] --> L["Integration Tests"]
    L -->|"Pass"| M["Build & Push"]
    L -->|"Fail"| N["Stop"]
```