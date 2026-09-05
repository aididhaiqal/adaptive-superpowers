#!/usr/bin/env python3
"""Check our deliberately narrow UI-metadata format, not model activation."""
import json
import pathlib
import unittest

ROOT = pathlib.Path(__file__).resolve().parents[2]


class MetadataTests(unittest.TestCase):
    def test_every_skill_has_presentation_only_metadata(self):
        skills = sorted((ROOT / "skills").glob("*/SKILL.md"))
        self.assertEqual(len(skills), 13)
        for skill in skills:
            with self.subTest(skill=skill.parent.name):
                path = skill.parent / "agents/openai.yaml"
                self.assertTrue(path.is_file(), f"missing UI metadata: {path}")
                lines = path.read_text().splitlines()
                self.assertEqual(lines[0], "interface:")
                fields = {}
                for line in lines[1:]:
                    self.assertTrue(line.startswith("  "), "only interface fields are expected")
                    key, value = line.strip().split(":", 1)
                    self.assertNotIn(key, fields)
                    fields[key] = json.loads(value.strip())  # quoted YAML strings in this format
                    self.assertIsInstance(fields[key], str)
                self.assertTrue({"display_name", "short_description"} <= fields.keys())
                self.assertFalse(fields.keys() - {"display_name", "short_description", "default_prompt"})
                self.assertTrue(fields["display_name"].strip())
                self.assertTrue(25 <= len(fields["short_description"]) <= 64)
                if "default_prompt" in fields:
                    self.assertIn(f"${skill.parent.name}", fields["default_prompt"])
                if skill.parent.name == "managing-project-state":
                    self.assertEqual(fields, {
                        "display_name": "Managing Project State",
                        "short_description": "Keep durable project state concise and complete",
                        "default_prompt": "Use $managing-project-state to reconcile this project’s canonical current state without weakening unresolved commitments.",
                    })
                # No policy override: native implicit invocation keeps its default true.


if __name__ == "__main__":
    unittest.main()
