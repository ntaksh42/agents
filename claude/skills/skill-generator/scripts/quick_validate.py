#!/usr/bin/env python3
"""
Quick validation script for skills - minimal version
"""

import sys
import os
import re
import yaml
from pathlib import Path

# Description length thresholds
DESCRIPTION_RECOMMENDED_MAX = 200  # Optimal for Claude.ai triggering
DESCRIPTION_ABSOLUTE_MAX = 1024    # Agent Skills specification limit


def validate_skill(skill_path):
    """
    Basic validation of a skill.

    Returns:
        Tuple of (is_valid: bool, message: str, warnings: list[str])
    """
    skill_path = Path(skill_path)
    warnings = []

    # Check SKILL.md exists
    skill_md = skill_path / 'SKILL.md'
    if not skill_md.exists():
        return False, "SKILL.md not found", warnings

    # Read and validate frontmatter
    content = skill_md.read_text()
    if not content.startswith('---'):
        return False, "No YAML frontmatter found", warnings

    # Extract frontmatter
    match = re.match(r'^---\n(.*?)\n---', content, re.DOTALL)
    if not match:
        return False, "Invalid frontmatter format", warnings

    frontmatter_text = match.group(1)

    # Parse YAML frontmatter
    try:
        frontmatter = yaml.safe_load(frontmatter_text)
        if not isinstance(frontmatter, dict):
            return False, "Frontmatter must be a YAML dictionary", warnings
    except yaml.YAMLError as e:
        return False, f"Invalid YAML in frontmatter: {e}", warnings

    # Define allowed properties
    ALLOWED_PROPERTIES = {
        'name', 'description', 'license', 'dependencies',
        'allowed-tools', 'metadata', 'compatibility'
    }

    # Check for unexpected properties (excluding nested keys under metadata)
    unexpected_keys = set(frontmatter.keys()) - ALLOWED_PROPERTIES
    if unexpected_keys:
        return False, (
            f"Unexpected key(s) in SKILL.md frontmatter: {', '.join(sorted(unexpected_keys))}. "
            f"Allowed properties are: {', '.join(sorted(ALLOWED_PROPERTIES))}"
        ), warnings

    # Check required fields
    if 'name' not in frontmatter:
        return False, "Missing 'name' in frontmatter", warnings
    if 'description' not in frontmatter:
        return False, "Missing 'description' in frontmatter", warnings

    # Extract name for validation
    name = frontmatter.get('name', '')
    if not isinstance(name, str):
        return False, f"Name must be a string, got {type(name).__name__}", warnings
    name = name.strip()
    if name:
        # Check naming convention (kebab-case: lowercase with hyphens)
        if not re.match(r'^[a-z0-9-]+$', name):
            return False, f"Name '{name}' should be kebab-case (lowercase letters, digits, and hyphens only)", warnings
        if name.startswith('-') or name.endswith('-') or '--' in name:
            return False, f"Name '{name}' cannot start/end with hyphen or contain consecutive hyphens", warnings
        # Check name length (max 64 characters per spec)
        if len(name) > 64:
            return False, f"Name is too long ({len(name)} characters). Maximum is 64 characters.", warnings

    # Extract and validate description
    description = frontmatter.get('description', '')
    if not isinstance(description, str):
        return False, f"Description must be a string, got {type(description).__name__}", warnings
    description = description.strip()
    if description:
        # Check for angle brackets
        if '<' in description or '>' in description:
            return False, "Description cannot contain angle brackets (< or >)", warnings
        # Check description length - warning at recommended, error at absolute max
        if len(description) > DESCRIPTION_ABSOLUTE_MAX:
            return False, f"Description is too long ({len(description)} characters). Maximum is {DESCRIPTION_ABSOLUTE_MAX} characters.", warnings
        if len(description) > DESCRIPTION_RECOMMENDED_MAX:
            warnings.append(
                f"Description is {len(description)} characters. "
                f"Recommend keeping under {DESCRIPTION_RECOMMENDED_MAX} characters for optimal triggering on Claude.ai "
                f"(maximum allowed: {DESCRIPTION_ABSOLUTE_MAX})."
            )

    # Validate compatibility field if present (optional)
    compatibility = frontmatter.get('compatibility', '')
    if compatibility:
        if not isinstance(compatibility, str):
            return False, f"Compatibility must be a string, got {type(compatibility).__name__}", warnings
        if len(compatibility) > 500:
            return False, f"Compatibility is too long ({len(compatibility)} characters). Maximum is 500 characters.", warnings

    # Validate dependencies field if present (optional)
    dependencies = frontmatter.get('dependencies', '')
    if dependencies:
        if not isinstance(dependencies, str):
            return False, f"Dependencies must be a string, got {type(dependencies).__name__}", warnings

    return True, "Skill is valid!", warnings


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python quick_validate.py <skill_directory>")
        sys.exit(1)

    valid, message, warnings = validate_skill(sys.argv[1])

    # Print warnings first
    for warning in warnings:
        print(f"⚠️  Warning: {warning}")

    # Print result
    if valid:
        print(f"✅ {message}")
    else:
        print(f"❌ {message}")

    sys.exit(0 if valid else 1)
