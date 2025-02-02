# Zuru Project
Zuru Tech Assessment Phase 1

# Details
This branch only consists the project's core file for a local environment, just for testing the app function.
The files are well-documented and well-commented for make them clear.
Also followed best practices and lease-privileged approach.

After cloning the repository you just need to build the stack up:
docker-compose up --build

For testing the app function:
Invoke-WebRequest http://localhost:8080/health or curl http://localhost:8080/health  # Should return "200 - OK"
