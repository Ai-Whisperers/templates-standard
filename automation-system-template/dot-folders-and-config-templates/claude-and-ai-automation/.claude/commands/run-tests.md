---
description: Run the full test suite with proper configuration
---

# Run Full Test Suite

!PYTHONPATH=".:$PYTHONPATH" timeout 120 python -m pytest -v --tb=short

# CUSTOMIZATION NOTES:
# - Adjust PYTHONPATH for your project structure
# - Change timeout value (120s) based on test suite duration
# - Add coverage flags: --cov=app --cov-report=html
# - Specify test directories: pytest tests/unit tests/integration
# - Add test markers: pytest -m "not slow"
