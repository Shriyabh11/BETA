import os
import shutil
from pathlib import Path

def create_directory_structure():
    """Create the new directory structure."""
    base_dir = Path(__file__).parent
    
    # Define the new structure
    directories = [
        "services/health_logger/app/api",
        "services/health_logger/app/models",
        "services/health_logger/app/config",
        "services/health_qa/app/api",
        "services/health_qa/app/models",
        "services/health_qa/app/config",
        "services/mental_health/app/api",
        "services/mental_health/app/models",
        "services/mental_health/app/config",
        "common/utils",
        "common/config"
    ]
    
    # Create directories
    for dir_path in directories:
        full_path = base_dir / dir_path
        full_path.mkdir(parents=True, exist_ok=True)
        print(f"Created directory: {full_path}")

def move_files():
    """Move files to their new locations."""
    base_dir = Path(__file__).parent
    
    # Move logging agent files
    if os.path.exists("logging_agent"):
        shutil.move("logging_agent/app", "services/health_logger/")
        if os.path.exists("logging_agent/requirements.txt"):
            shutil.move("logging_agent/requirements.txt", "services/health_logger/")
        print("Moved logging agent files")
    
    # Move Q&A agent files
    if os.path.exists("q&a_agent"):
        shutil.move("q&a_agent/app", "services/health_qa/")
        if os.path.exists("q&a_agent/requirements.txt"):
            shutil.move("q&a_agent/requirements.txt", "services/health_qa/")
        print("Moved Q&A agent files")
    
    # Move mental health agent files
    if os.path.exists("mental_health_agent"):
        shutil.move("mental_health_agent/app", "services/mental_health/")
        if os.path.exists("mental_health_agent/requirements.txt"):
            shutil.move("mental_health_agent/requirements.txt", "services/mental_health/")
        print("Moved mental health agent files")

def main():
    print("Starting restructuring...")
    create_directory_structure()
    move_files()
    print("Restructuring complete!")

if __name__ == "__main__":
    main() 