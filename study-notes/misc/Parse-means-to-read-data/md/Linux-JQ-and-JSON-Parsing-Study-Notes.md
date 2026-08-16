# Linux `jq` Command and JSON Parsing — Study Notes

## Learning objectives

After studying these notes, you should be able to:

- Explain what `jq` is and why JSON needs a structured parser.
- Navigate JSON objects, arrays, and nested values.
- Filter, select, transform, sort, group, and calculate JSON data.
- Produce raw text, compact JSON, CSV, and TSV output.
- Pass shell values safely into JQ programs.
- Validate and update JSON files safely.
- Use `jq` in Linux Administrator and DevOps workflows.

---

## 1. What is `jq`?

`jq` is a command-line tool used to read, filter, transform, and format JSON data.

JSON means:

```text
JavaScript Object Notation
```

In simple words:

> `jq` is like `awk`, `sed`, and `grep`, but it is specifically designed for structured JSON data.

It is commonly used with:

- REST APIs
- AWS CLI
- Docker
- Kubernetes
- GitHub APIs
- Monitoring tools
- Configuration files
- Shell scripts

The official command name is simply lowercase `jq`. It is commonly described as a JSON query or JSON-processing tool.

---

## 2. Why do we need `jq`?

Consider:

```json
{
  "name": "web01",
  "status": "running",
  "usage": 25
}
```

Text tools such as `grep` do not understand JSON objects, keys, arrays, nesting, or data types. JQ understands the structure.

```bash
jq '.name' server.json
```

Output:

```json
"web01"
```

Raw text without quotes:

```bash
jq -r '.name' server.json
```

Output:

```text
web01
```

---

## 3. Is `jq` a parsing tool?

Yes. JQ is specifically designed to parse JSON.

```text
JSON input → jq filter → selected or transformed output
```

Example:

```bash
jq '.servers[] | select(.status == "running") | .name' servers.json
```

This:

1. Opens the `servers` array.
2. Processes every item.
3. Selects objects whose status is `running`.
4. Displays their names.

---

## 4. Installation and syntax

### Ubuntu or Debian

```bash
sudo apt update
sudo apt install jq
```

### RHEL, AlmaLinux, Rocky Linux, or Fedora

```bash
sudo dnf install jq
```

### Check the version

```bash
jq --version
```

### Basic syntax

```bash
jq [OPTIONS] 'FILTER' [FILE]
```

Example:

```bash
jq '.name' server.json
```

| Part | Meaning |
|---|---|
| `jq` | Runs the JSON processor |
| `'...'` | Contains the JQ filter |
| `.name` | Selects the `name` key |
| `server.json` | Input JSON file |

---

## 5. Create a practice JSON file

```bash
cat > servers.json <<'EOF'
{
  "environment": "production",
  "servers": [
    {
      "name": "web01",
      "status": "running",
      "usage": 25,
      "ip": "10.0.1.10"
    },
    {
      "name": "web02",
      "status": "stopped",
      "usage": 80,
      "ip": "10.0.1.11"
    },
    {
      "name": "db01",
      "status": "running",
      "usage": 65,
      "ip": "10.0.2.10"
    }
  ]
}
EOF
```

Validate and format it:

```bash
jq '.' servers.json
```

---

## 6. Identity filter and JSON types

A single dot selects the complete input:

```bash
jq '.' servers.json
```

This validates and pretty-prints JSON. Invalid input causes a parse error.

### JSON data types

| Type | Example |
|---|---|
| Object | `{"name":"web01"}` |
| Array | `["web01","web02"]` |
| String | `"running"` |
| Number | `25` |
| Boolean | `true` |
| Null | `null` |

Check a value’s type:

```bash
jq '.servers | type' servers.json
```

Output:

```json
"array"
```

---

## 7. Selecting fields and nested data

### Select one field

```bash
jq '.environment' servers.json
```

### Raw text output

```bash
jq -r '.environment' servers.json
```

### Select the complete array

```bash
jq '.servers' servers.json
```

### Create a summary object

```bash
jq '{
  environment: .environment,
  server_count: (.servers | length)
}' servers.json
```

### Select the first array item

```bash
jq '.servers[0]' servers.json
```

Arrays begin at index `0`.

### Select the first server’s name

```bash
jq '.servers[0].name' servers.json
```

### Select the last item

```bash
jq '.servers[-1]' servers.json
```

---

## 8. Process array items with `[]`

```bash
jq '.servers[]' servers.json
```

Display every name:

```bash
jq '.servers[] | .name' servers.json
```

Shorter form:

```bash
jq '.servers[].name' servers.json
```

Raw output:

```bash
jq -r '.servers[].name' servers.json
```

Output:

```text
web01
web02
db01
```

---

## 9. JQ pipes versus shell pipes

Inside a JQ filter, `|` sends one filter’s result to the next:

```bash
jq '.servers[] | .name' servers.json
```

```text
.servers → [] processes each item → .name selects the name
```

A shell pipe appears outside the quoted filter:

```bash
command-producing-json | jq '.'
```

---

## 10. Filtering with `select()`

### Running servers

```bash
jq '.servers[] | select(.status == "running")' servers.json
```

### Their names

```bash
jq -r '
  .servers[]
  | select(.status == "running")
  | .name
' servers.json
```

### Usage above 50

```bash
jq '
  .servers[]
  | select(.usage > 50)
' servers.json
```

### Formatted result

```bash
jq -r '
  .servers[]
  | select(.usage > 50)
  | "\(.name) \(.usage)%"
' servers.json
```

### Comparison operators

| Operator | Meaning |
|---|---|
| `==` | Equal to |
| `!=` | Not equal to |
| `>` | Greater than |
| `<` | Less than |
| `>=` | Greater than or equal to |
| `<=` | Less than or equal to |

### Combine conditions

```bash
# AND
jq '.servers[] | select(.status == "running" and .usage > 50)' servers.json

# OR
jq '.servers[] | select(.name == "web01" or .name == "db01")' servers.json

# Not equal
jq '.servers[] | select(.status != "running")' servers.json
```

---

## 11. Output modes: `-r` and `-c`

### Raw output with `-r`

```bash
jq -r '.environment' servers.json
```

Use raw output for shell variables, text files, reports, or other text commands.

```bash
environment=$(jq -r '.environment' servers.json)
echo "$environment"
```

### Compact output with `-c`

```bash
jq -c '.servers[]' servers.json
```

Possible output:

```json
{"name":"web01","status":"running","usage":25,"ip":"10.0.1.10"}
{"name":"web02","status":"stopped","usage":80,"ip":"10.0.1.11"}
{"name":"db01","status":"running","usage":65,"ip":"10.0.2.10"}
```

Compact JSON is useful for logs, JSON Lines, pipelines, and reduced output size.

---

## 12. String interpolation and reports

JQ inserts values in strings with `\(...)`:

```bash
jq -r '
  .servers[]
  | "Server \(.name) is \(.status)"
' servers.json
```

Formatted report:

```bash
jq -r '
  .servers[]
  | "\(.name) | \(.status) | \(.usage)% | \(.ip)"
' servers.json
```

---

## 13. Build objects and arrays

### Create new objects

```bash
jq '
  .servers[]
  | {
      hostname: .name,
      state: .status,
      cpu_usage: .usage
    }
' servers.json
```

Short object syntax:

```bash
jq '.servers[] | {name, status, usage}' servers.json
```

### Collect values in an array

```bash
jq '
  [
    .servers[]
    | select(.status == "running")
    | .name
  ]
' servers.json
```

Without surrounding brackets, JQ produces separate results instead of one array.

---

## 14. Transform arrays with `map()`

`map()` runs a filter against every array item and returns a new array.

```bash
# Extract all names
jq '.servers | map(.name)' servers.json

# Keep running servers
jq '.servers | map(select(.status == "running"))' servers.json

# Increase usage in generated output
jq '.servers | map(.usage += 5)' servers.json
```

These commands transform generated output, not the original file.

---

## 15. Count, inspect keys, and calculate

### Count servers

```bash
jq '.servers | length' servers.json
```

### Get object keys

```bash
jq '.servers[0] | keys' servers.json
```

### Convert object properties to entries

```bash
jq '.servers[0] | to_entries' servers.json
```

### Total usage

```bash
jq '[.servers[].usage] | add' servers.json
```

### Average usage safely

```bash
jq '
  [.servers[].usage]
  | if length > 0 then add / length else 0 end
' servers.json
```

### Count running servers

```bash
jq '
  [.servers[] | select(.status == "running")]
  | length
' servers.json
```

---

## 16. Sort, find minimum/maximum, group, and deduplicate

### Sort by usage

```bash
jq '.servers | sort_by(.usage)' servers.json
```

### Highest first

```bash
jq '.servers | sort_by(.usage) | reverse' servers.json
```

### Multiple sorting values

```bash
jq '.servers | sort_by(.status, .usage)' servers.json
```

### Minimum and maximum

```bash
jq '.servers | min_by(.usage)' servers.json
jq '.servers | max_by(.usage)' servers.json
jq -r '.servers | max_by(.usage) | .name' servers.json
```

### Group by status

```bash
jq '.servers | group_by(.status)' servers.json
```

### Status summary

```bash
jq '
  .servers
  | group_by(.status)
  | map({status: .[0].status, count: length})
' servers.json
```

### Unique status values

```bash
jq '.servers | map(.status) | unique' servers.json
```

### One object per unique status key

```bash
jq '.servers | unique_by(.status)' servers.json
```

---

## 17. Update and delete values

### Change a top-level value

```bash
jq '.environment = "staging"' servers.json
```

### Update matching objects

```bash
jq '
  .servers |= map(
    if .status == "stopped"
    then .status = "maintenance"
    else .
    end
  )
' servers.json
```

### Add a field

```bash
jq '.servers[] | .region = "us-central"' servers.json
```

### Delete fields

```bash
jq '.servers | map(del(.ip))' servers.json
```

### Remove an array item

```bash
jq '.servers | map(select(.name != "web02"))' servers.json
```

These filters transform output; they do not edit the original file by default.

---

## 18. Missing and null values

### Default value with `//`

```bash
jq -r '.servers[] | .region // "unknown"' servers.json
```

`//` supplies a fallback when the left side is `null` or `false`.

### Optional lookup with `?`

```bash
jq '.servers[] | .region?' servers.json
```

The optional operator can suppress some errors from missing or incompatible paths.

### Test whether a key exists

```bash
jq '.servers[] | select(has("ip"))' servers.json
```

---

## 19. Validate JSON and use exit statuses

### Pretty-print and validate

```bash
jq '.' servers.json
```

### Validate without normal output

```bash
jq empty servers.json
```

### Use in a shell script

```bash
if jq empty servers.json 2>/dev/null; then
    echo "Valid JSON"
else
    echo "Invalid JSON" >&2
    exit 1
fi
```

### `-e` for meaningful exit status

```bash
jq -e '.servers | length > 0' servers.json
echo $?
```

In general:

- Truthy final result: status `0`
- Final result is `false` or `null`: status `1`
- Parsing, compile, or usage problem: another nonzero status

Example:

```bash
if jq -e '.environment == "production"' servers.json >/dev/null; then
    echo "Production environment"
fi
```

---

## 20. Pass shell values safely

### String value with `--arg`

```bash
required_status="running"

jq --arg status "$required_status" '
  .servers[]
  | select(.status == $status)
' servers.json
```

### Number or JSON value with `--argjson`

```bash
minimum_usage=50

jq --argjson minimum "$minimum_usage" '
  .servers[]
  | select(.usage > $minimum)
' servers.json
```

| Option | Value type |
|---|---|
| `--arg` | Always passes a JSON string |
| `--argjson` | Parses the supplied text as JSON |

Filters should normally use single quotes. Single quotes stop the shell from interpreting JQ variables, parentheses, backslashes, wildcards, and pipe operators.

---

## 21. Slurp mode and raw input mode

Suppose `events.jsonl` contains separate JSON objects:

```json
{"event":"login","user":"ali"}
{"event":"logout","user":"sara"}
{"event":"login","user":"khalid"}
```

### Slurp into one array with `-s`

```bash
jq -s '.' events.jsonl
```

Count records:

```bash
jq -s 'length' events.jsonl
```

### Read plain text with `-R`

```bash
printf '%s\n' web01 web02 db01 | jq -R '.'
```

### Build an array from lines

```bash
printf '%s\n' web01 web02 db01 |
jq -R -s 'split("\n") | map(select(length > 0))'
```

---

## 22. Command and API output examples

General pattern:

```bash
command-producing-json | jq '.'
```

### AWS CLI-style JSON

```bash
aws ec2 describe-instances --output json |
jq '.Reservations[].Instances[] | {
  id: .InstanceId,
  state: .State.Name
}'
```

### Kubernetes JSON

```bash
kubectl get pods -o json |
jq -r '.items[] | "\(.metadata.name) \(.status.phase)"'
```

### Docker inspection JSON

```bash
docker inspect container-name |
jq '.[0] | {name: .Name, state: .State.Status}'
```

The relevant commands must be installed, authorized, and return the expected schemas.

---

## 23. Administrator reports and output formats

### Threshold alert

```bash
jq -r '
  .servers[]
  | select(.usage >= 80)
  | "ALERT: \(.name) usage is \(.usage)%"
' servers.json
```

### Tab-separated output

```bash
jq -r '
  .servers[]
  | [.name, .status, .usage, .ip]
  | @tsv
' servers.json
```

### CSV output

```bash
jq -r '
  .servers[]
  | [.name, .status, .usage, .ip]
  | @csv
' servers.json
```

### Output format filters

| Filter | Purpose |
|---|---|
| `@csv` | Format an array as CSV |
| `@tsv` | Format an array as tab-separated text |
| `@json` | Encode a value as JSON text |
| `@uri` | Percent-encode a URI component |
| `@base64` | Base64-encode input |
| `@sh` | Escape text for a POSIX shell command line |

---

## 24. Save transformed JSON safely

Save to another file:

```bash
jq '.environment = "staging"' servers.json > servers-new.json
```

Do not use:

```bash
jq '.environment = "staging"' servers.json > servers.json
```

The shell may empty the input before JQ reads it.

### Safe temporary-file workflow

```bash
jq '.environment = "staging"' servers.json > servers.tmp &&
mv servers.tmp servers.json
```

### Safer workflow with backup and validation

```bash
cp servers.json servers.json.bak

jq '.environment = "staging"' servers.json > servers.tmp &&
jq empty servers.tmp &&
mv servers.tmp servers.json
```

This creates a backup, generates a temporary file, validates it, and replaces the original only after success.

---

## 25. Handle sensitive data carefully

JSON output may contain passwords, API tokens, access keys, private addresses, or personal data.

Remove sensitive fields:

```bash
jq 'del(.password, .token, .secret)' response.json
```

Mask a value:

```bash
jq '
  if has("token")
  then .token = "[REDACTED]"
  else .
  end
' response.json
```

Avoid exposing secrets through terminal history, debug output, logs, screenshots, or shared reports.

---

## 26. JQ versus text-processing tools

| Command | Main purpose |
|---|---|
| `grep` | Search or filter text lines |
| `cut` | Extract simple delimited fields |
| `awk` | Process text fields, conditions, and calculations |
| `sed` | Edit and transform text streams |
| `sort` | Arrange text records |
| `jq` | Parse, filter, transform, and format JSON |

Fragile approach:

```bash
grep '"status"' servers.json
```

Structured approach:

```bash
jq '.servers[].status' servers.json
```

JQ understands nesting, arrays, strings, numbers, booleans, null, formatting changes, and valid JSON output.

---

## 27. Common mistakes

### Forgetting the initial dot

```bash
# Incorrect
jq 'servers' servers.json

# Correct
jq '.servers' servers.json
```

### Forgetting array iteration

```bash
jq '.servers' servers.json
jq '.servers[]' servers.json
```

The first selects the array; the second processes every item.

### Forgetting raw output

```bash
jq -r '.servers[].name' servers.json
```

### Using unsafe shell interpolation

Prefer:

```bash
jq --arg status "$status" '
  .servers[] | select(.status == $status)
' servers.json
```

### Confusing JQ and shell pipes

```bash
# JQ pipe inside quotes
jq '.servers[] | .name' servers.json

# Shell pipe outside quotes
cat servers.json | jq '.servers[].name'
```

### Overwriting the input directly

Do not use `jq ... file > file`; use a validated temporary file.

### Confusing numbers and strings

```bash
# String
jq --arg value "80" ...

# Number
jq --argjson value 80 ...
```

---

## 28. Thinking process before using `jq`

Ask:

1. Is the input valid JSON?
2. Is the top-level value an object or array?
3. Which path contains the required data?
4. Do I need one value or every array item?
5. Do I need `select()` filtering?
6. Should output remain JSON or become raw text?
7. Do I need to sort, group, count, or calculate?
8. Are missing or null fields possible?
9. Am I handling sensitive data?
10. Should the result only be displayed or safely saved?

Basic flow:

```text
JSON input → path → array iteration → condition → transformation → output format
```

Example:

```bash
jq -r '
  .servers[]
  | select(.status == "running")
  | "\(.name) \(.usage)%"
' servers.json
```

---

## 29. Practice lab

Using `servers.json`, complete these tasks:

1. Display formatted JSON.
2. Display the environment without quotes.
3. Display every server name.
4. Display running-server objects.
5. Display names with usage above 50.
6. Count all servers.
7. Count running servers.
8. Sort by usage from lowest to highest.
9. Display the highest-usage server.
10. Create an array containing server names.
11. Create objects containing only name and status.
12. Produce CSV output with name, status, usage, and IP.
13. Change `web02` from `stopped` to `maintenance` in output.
14. Remove all IP fields from output.
15. Calculate total and average usage.
16. Validate JSON without displaying it.

### Solutions

```bash
# 1. Format complete JSON
jq '.' servers.json

# 2. Environment without quotes
jq -r '.environment' servers.json

# 3. Every server name
jq -r '.servers[].name' servers.json

# 4. Running servers
jq '.servers[] | select(.status == "running")' servers.json

# 5. Names with usage above 50
jq -r '
  .servers[]
  | select(.usage > 50)
  | .name
' servers.json

# 6. Count all servers
jq '.servers | length' servers.json

# 7. Count running servers
jq '[.servers[] | select(.status == "running")] | length' servers.json

# 8. Sort by usage
jq '.servers | sort_by(.usage)' servers.json

# 9. Highest-usage server
jq '.servers | max_by(.usage)' servers.json

# 10. Array of names
jq '.servers | map(.name)' servers.json

# 11. Name and status objects
jq '.servers | map({name, status})' servers.json

# 12. CSV output
jq -r '.servers[] | [.name, .status, .usage, .ip] | @csv' servers.json

# 13. Change web02 status in generated output
jq '
  .servers |= map(
    if .name == "web02"
    then .status = "maintenance"
    else .
    end
  )
' servers.json

# 14. Remove IP fields
jq '.servers |= map(del(.ip))' servers.json

# 15. Total and average usage
jq '
  [.servers[].usage]
  | {
      total: add,
      average: (if length > 0 then add / length else 0 end)
    }
' servers.json

# 16. Validate without normal output
jq empty servers.json
```

---

## 30. Quick knowledge check

1. What kind of data does `jq` process?
2. What does the identity filter `.` mean?
3. What is the difference between `.servers` and `.servers[]`?
4. What does `select()` do?
5. Why is `-r` useful?
6. What does `-c` do?
7. What is the purpose of `map()`?
8. How do `length`, `add`, `min_by()`, and `max_by()` work?
9. What does `//` do?
10. What is the difference between `--arg` and `--argjson`?
11. What do `-s` and `-R` do?
12. Why should filters normally use single quotes?
13. How do you validate JSON?
14. Why should transformed output use a temporary file?
15. Why is `jq` better than `grep` for JSON?

---

## 31. Quick reference

```bash
# Format or validate JSON
jq '.' file.json

# Validate without output
jq empty file.json

# Select one field
jq '.name' file.json

# Raw string output
jq -r '.name' file.json

# Process every array item
jq '.items[]' file.json

# Select nested data
jq '.items[0].name' file.json

# Filter records
jq '.items[] | select(.status == "running")' file.json

# Create a new object
jq '.items[] | {name, status}' file.json

# Create an array
jq '[.items[].name]' file.json

# Transform every array item
jq '.items | map(.name)' file.json

# Count items
jq '.items | length' file.json

# Sort by a field
jq '.items | sort_by(.usage)' file.json

# Find maximum
jq '.items | max_by(.usage)' file.json

# Total numbers
jq '[.items[].usage] | add' file.json

# Default value
jq '.region // "unknown"' file.json

# Compact output
jq -c '.items[]' file.json

# Pass a shell string
jq --arg value "$variable" '.key = $value' file.json

# Pass a JSON value
jq --argjson value "$number" '.key = $value' file.json

# Slurp inputs into an array
jq -s '.' records.jsonl

# Read plain text lines
jq -R '.' file.txt

# CSV output
jq -r '.items[] | [.name, .status] | @csv' file.json

# TSV output
jq -r '.items[] | [.name, .status] | @tsv' file.json
```

## Final summary

`jq` is a command-line JSON processor used to parse, filter, transform, calculate, sort, and format structured JSON data.

Remember:

```text
grep = search text lines
cut  = extract simple text fields
awk  = process text records and fields
sed  = edit text streams
sort = arrange text records
jq   = parse and transform JSON
```
