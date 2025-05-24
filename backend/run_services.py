import subprocess
import sys
import os
import time
import logging
from pathlib import Path
from typing import Optional, List

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

class ServiceManager:
    def __init__(self):
        self.processes: List[subprocess.Popen] = []
        self.backend_dir = Path(__file__).parent
        self.services = [
            ("Health Logger", 8000, "services.health_logger.app.main"),
            ("Q&A", 8001, "services.health_qa.app.main"),
            ("Mental Health", 8002, "services.mental_health.app.main")
        ]

    def run_service(self, service_name: str, port: int, module_path: str) -> Optional[subprocess.Popen]:
        """Run a service using uvicorn"""
        logger.info(f"🚀 Starting {service_name}...")
        try:
            # Change to the backend directory
            os.chdir(self.backend_dir)
            
            # Add the service directory to PYTHONPATH
            service_dir = self.backend_dir / module_path.split('.')[0]
            env = os.environ.copy()
            env["PYTHONPATH"] = str(service_dir) + os.pathsep + env.get("PYTHONPATH", "")
            
            # Run the service
            process = subprocess.Popen([
                sys.executable, "-m", "uvicorn",
                f"{module_path}:app",
                "--host", "0.0.0.0",
                "--port", str(port),
                "--reload"
            ], env=env)
            
            # Wait a bit to check if the service starts successfully
            time.sleep(2)
            if process.poll() is not None:
                logger.error(f"❌ {service_name} failed to start")
                return None
                
            logger.info(f"✅ {service_name} running on http://localhost:{port}")
            return process
            
        except Exception as e:
            logger.error(f"❌ Error starting {service_name}: {str(e)}")
            return None

    def start_all_services(self):
        """Start all services"""
        for service_name, port, module_path in self.services:
            process = self.run_service(service_name, port, module_path)
            if process:
                self.processes.append(process)
            else:
                self.stop_all_services()
                sys.exit(1)

    def stop_all_services(self):
        """Stop all running services"""
        logger.info("🛑 Stopping all services...")
        for process in self.processes:
            try:
                process.terminate()
                process.wait(timeout=5)
            except subprocess.TimeoutExpired:
                process.kill()
        logger.info("✅ All services stopped")

    def monitor_services(self):
        """Monitor running services"""
        try:
            while True:
                for i, process in enumerate(self.processes):
                    if process.poll() is not None:
                        service_name = self.services[i][0]
                        logger.error(f"❌ {service_name} has stopped unexpectedly")
                        self.stop_all_services()
                        return
                time.sleep(1)
        except KeyboardInterrupt:
            self.stop_all_services()

def main():
    manager = ServiceManager()
    manager.start_all_services()
    manager.monitor_services()

if __name__ == "__main__":
    main() 