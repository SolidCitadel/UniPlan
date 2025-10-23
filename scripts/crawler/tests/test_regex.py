import requests
import re

print("Fetching data.js...")
r = requests.get('https://sugang.khu.ac.kr/resources/data/data_2025.js')
content = r.text

print(f"Content length: {len(content)}")

# Test start pattern
start_match = re.search(r'var\s+major_202510\s*=', content)
print(f"\n1. Start match found: {start_match is not None}")

if start_match:
    start_idx = start_match.end()
    print(f"   Start index: {start_idx}")

    snippet = content[start_idx:start_idx+500]
    print(f"\n2. Snippet after start:\n{snippet[:200]}")

    # Find next var
    next_var = re.search(r'\nvar\s+\w+', content[start_idx:])
    print(f"\n3. Next var found: {next_var is not None}")

    if next_var:
        print(f"   Next var at relative position: {next_var.start()}")
        end_idx = start_idx + next_var.start()
        print(f"   Absolute end index: {end_idx}")

        # Extract section
        test_section = content[start_idx:end_idx]
        print(f"\n4. Section length: {len(test_section)}")

        # Show first record structure
        print(f"\n5. First 500 chars of section:")
        print(test_section[:500])

        # Test patterns
        print(f"\n6. Testing different patterns:")

        # Pattern 1: cd before nm
        pattern1 = r'"cd"\s*:\s*"([^"]+)"[^}]*"nm"\s*:\s*"([^"]+)"'
        matches1 = re.findall(pattern1, test_section)
        print(f"   Pattern 1 (cd before nm): {len(matches1)} matches")

        # Pattern 2: nm before cd
        pattern2 = r'"nm"\s*:\s*"([^"]+)"[^}]*"cd"\s*:\s*"([^"]+)"'
        matches2 = re.findall(pattern2, test_section)
        print(f"   Pattern 2 (nm before cd): {len(matches2)} matches")

        # Pattern 3: just cd
        pattern3 = r'"cd"\s*:\s*"([^"]+)"'
        matches3 = re.findall(pattern3, test_section)
        print(f"   Pattern 3 (just cd): {len(matches3)} matches")

        # Pattern 4: just nm
        pattern4 = r'"nm"\s*:\s*"([^"]+)"'
        matches4 = re.findall(pattern4, test_section)
        print(f"   Pattern 4 (just nm): {len(matches4)} matches")

        if matches2:
            print(f"\n7. First 5 matches (nm, cd):")
            for name, code in matches2[:5]:
                print(f"   {code}: {name}")
