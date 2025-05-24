import os
import shutil
from pathlib import Path

def reorganize_structure():
    # Define new structure
    new_structure = {
        'logging_agent': 'backend/services/health_logger',
        'q&a_agent': 'backend/services/health_qa',
        'mental_health_agent': 'backend/services/mental_health'
    }
    
    # Create backend/services directory if it doesn't exist
    os.makedirs('backend/services', exist_ok=True)
    
    # Move each directory
    for old_name, new_path in new_structure.items():
        if os.path.exists(old_name):
            # Create new directory
            os.makedirs(new_path, exist_ok=True)
            
            # Move contents
            for item in os.listdir(old_name):
                src = os.path.join(old_name, item)
                dst = os.path.join(new_path, item)
                if os.path.exists(dst):
                    shutil.rmtree(dst) if os.path.isdir(dst) else os.remove(dst)
                shutil.move(src, dst)
            
            # Remove old directory
            shutil.rmtree(old_name)
            print(f"Moved {old_name} to {new_path}")

if __name__ == "__main__":
    reorganize_structure() 