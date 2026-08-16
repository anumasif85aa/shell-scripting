# Linux `jq` Command aur JSON Parsing — Roman Urdu Study Notes

## Learning objectives

In notes ko parhne ke baad aap:

- Samjha sakenge ke `jq` kya hai aur JSON ko structured parser kyun chahiye.
- JSON objects, arrays aur nested values navigate kar sakenge.
- JSON data ko filter, select, transform, sort, group aur calculate kar sakenge.
- Raw text, compact JSON, CSV aur TSV output bana sakenge.
- Shell values ko safely JQ programs mein pass kar sakenge.
- JSON files validate aur safely update kar sakenge.
- Linux Administrator aur DevOps workflows mein `jq` use kar sakenge.

---

## 1. `jq` kya hai?

`jq` ek command-line tool hai jo JSON data ko read, filter, transform aur format karta hai.

JSON ka full form:

```text
JavaScript Object Notation
```

Asaan alfaaz mein:

> `jq`, `awk`, `sed` aur `grep` jaisa powerful tool hai, lekin yeh specially structured JSON data ke liye bana hai.

Yeh commonly in ke saath use hota hai:

- REST APIs
- AWS CLI
- Docker
- Kubernetes
- GitHub APIs
- Monitoring tools
- Configuration files
- Shell scripts

Official command name lowercase `jq` hai. Isay aam tor par JSON query ya JSON-processing tool kaha jata hai.

---

## 2. Hamein `jq` ki zaroorat kyun hai?

Is JSON ko dekhein:

```json
{
  "name": "web01",
  "status": "running",
  "usage": 25
}
```

`grep` jaise text tools JSON objects, keys, arrays, nesting aur data types ko nahi samajhte. JQ JSON ki structure samajhta hai.

```bash
jq '.name' server.json
```

Output:

```json
"web01"
```

Quotes ke baghair raw text:

```bash
jq -r '.name' server.json
```

Output:

```text
web01
```

---

## 3. Kya `jq` parsing tool hai?

Ji haan. JQ specifically JSON parse karne ke liye design hua hai.

```text
JSON input → jq filter → selected ya transformed output
```

Example:

```bash
jq '.servers[] | select(.status == "running") | .name' servers.json
```

Yeh command:

1. `servers` array kholti hai.
2. Har item process karti hai.
3. `running` status wale objects select karti hai.
4. Un ke names display karti hai.

---

## 4. Installation aur syntax

### Ubuntu ya Debian

```bash
sudo apt update
sudo apt install jq
```

### RHEL, AlmaLinux, Rocky Linux ya Fedora

```bash
sudo dnf install jq
```

### Version check karna

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

| Hissa | Matlab |
|---|---|
| `jq` | JSON processor run karta hai |
| `'...'` | JQ filter ko contain karta hai |
| `.name` | `name` key select karta hai |
| `server.json` | Input JSON file hai |

---

## 5. Practice JSON file banana

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

Validate aur format karein:

```bash
jq '.' servers.json
```

---

## 6. Identity filter aur JSON types

Single dot poora input select karta hai:

```bash
jq '.' servers.json
```

Yeh JSON ko validate aur pretty-print karta hai. Invalid JSON par parse error milta hai.

### JSON data types

| Type | Example |
|---|---|
| Object | `{"name":"web01"}` |
| Array | `["web01","web02"]` |
| String | `"running"` |
| Number | `25` |
| Boolean | `true` |
| Null | `null` |

Value ka type check karein:

```bash
jq '.servers | type' servers.json
```

Output:

```json
"array"
```

---

## 7. Fields aur nested data select karna

### Ek field select karna

```bash
jq '.environment' servers.json
```

### Raw text output

```bash
jq -r '.environment' servers.json
```

### Poora array select karna

```bash
jq '.servers' servers.json
```

### Summary object banana

```bash
jq '{
  environment: .environment,
  server_count: (.servers | length)
}' servers.json
```

### Pehla array item select karna

```bash
jq '.servers[0]' servers.json
```

Arrays ka index `0` se shuru hota hai.

### Pehle server ka name

```bash
jq '.servers[0].name' servers.json
```

### Aakhri item

```bash
jq '.servers[-1]' servers.json
```

---

## 8. `[]` se array items process karna

```bash
jq '.servers[]' servers.json
```

Har server ka name:

```bash
jq '.servers[] | .name' servers.json
```

Short form:

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

## 9. JQ pipe aur shell pipe

JQ filter ke andar `|` ek filter ka result doosre filter ko deta hai:

```bash
jq '.servers[] | .name' servers.json
```

```text
.servers → [] har item process karta hai → .name name select karta hai
```

Shell pipe quoted filter se bahar hota hai:

```bash
command-producing-json | jq '.'
```

---

## 10. `select()` se filtering

### Running servers

```bash
jq '.servers[] | select(.status == "running")' servers.json
```

### Running servers ke names

```bash
jq -r '
  .servers[]
  | select(.status == "running")
  | .name
' servers.json
```

### Usage 50 se zyada

```bash
jq '.servers[] | select(.usage > 50)' servers.json
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

| Operator | Matlab |
|---|---|
| `==` | Barabar |
| `!=` | Barabar nahi |
| `>` | Se zyada |
| `<` | Se kam |
| `>=` | Barabar ya zyada |
| `<=` | Barabar ya kam |

### Conditions combine karna

```bash
# AND
jq '.servers[] | select(.status == "running" and .usage > 50)' servers.json

# OR
jq '.servers[] | select(.name == "web01" or .name == "db01")' servers.json

# Not equal
jq '.servers[] | select(.status != "running")' servers.json
```

---

## 11. Output modes: `-r` aur `-c`

### `-r` se raw output

```bash
jq -r '.environment' servers.json
```

Raw output shell variables, text files, reports ya doosri text commands ke liye useful hai.

```bash
environment=$(jq -r '.environment' servers.json)
echo "$environment"
```

### `-c` se compact output

```bash
jq -c '.servers[]' servers.json
```

Possible output:

```json
{"name":"web01","status":"running","usage":25,"ip":"10.0.1.10"}
{"name":"web02","status":"stopped","usage":80,"ip":"10.0.1.11"}
{"name":"db01","status":"running","usage":65,"ip":"10.0.2.10"}
```

Compact JSON logs, JSON Lines, pipelines aur chhote output ke liye useful hai.

---

## 12. String interpolation aur reports

JQ strings mein values `\(...)` ke zariye insert karta hai:

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

## 13. Objects aur arrays banana

### Naye objects

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

### Values ko ek array mein collect karna

```bash
jq '
  [
    .servers[]
    | select(.status == "running")
    | .name
  ]
' servers.json
```

Outer brackets ke baghair JQ ek array ke bajaye separate results produce karega.

---

## 14. `map()` se arrays transform karna

`map()` har array item par filter run karke naya array return karta hai.

```bash
# Tamam names extract karna
jq '.servers | map(.name)' servers.json

# Running servers rakhna
jq '.servers | map(select(.status == "running"))' servers.json

# Generated output mein usage barhana
jq '.servers | map(.usage += 5)' servers.json
```

Yeh commands generated output transform karti hain, original file nahi.

---

## 15. Count, keys aur calculations

### Servers count karna

```bash
jq '.servers | length' servers.json
```

### Object keys hasil karna

```bash
jq '.servers[0] | keys' servers.json
```

### Properties ko entries mein badalna

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

### Running servers count karna

```bash
jq '[.servers[] | select(.status == "running")] | length' servers.json
```

---

## 16. Sort, minimum, maximum, grouping aur uniqueness

### Usage ke mutabiq sort

```bash
jq '.servers | sort_by(.usage)' servers.json
```

### Highest pehle

```bash
jq '.servers | sort_by(.usage) | reverse' servers.json
```

### Multiple sorting values

```bash
jq '.servers | sort_by(.status, .usage)' servers.json
```

### Minimum aur maximum

```bash
jq '.servers | min_by(.usage)' servers.json
jq '.servers | max_by(.usage)' servers.json
jq -r '.servers | max_by(.usage) | .name' servers.json
```

### Status ke mutabiq group

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

### Har unique status ke liye ek object

```bash
jq '.servers | unique_by(.status)' servers.json
```

---

## 17. Values update aur delete karna

### Top-level value change karna

```bash
jq '.environment = "staging"' servers.json
```

### Matching objects update karna

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

### Field add karna

```bash
jq '.servers[] | .region = "us-central"' servers.json
```

### Fields delete karna

```bash
jq '.servers | map(del(.ip))' servers.json
```

### Array item remove karna

```bash
jq '.servers | map(select(.name != "web02"))' servers.json
```

Yeh filters output transform karte hain; default tor par original file edit nahi hoti.

---

## 18. Missing aur null values

### `//` se default value

```bash
jq -r '.servers[] | .region // "unknown"' servers.json
```

`//` fallback deta hai jab left side `null` ya `false` ho.

### `?` se optional lookup

```bash
jq '.servers[] | .region?' servers.json
```

Optional operator missing ya incompatible paths ke kuch errors suppress kar sakta hai.

### Key ki mojoodgi check karna

```bash
jq '.servers[] | select(has("ip"))' servers.json
```

---

## 19. JSON validation aur exit statuses

### Pretty-print aur validate

```bash
jq '.' servers.json
```

### Normal output ke baghair validate

```bash
jq empty servers.json
```

### Shell script mein

```bash
if jq empty servers.json 2>/dev/null; then
    echo "Valid JSON"
else
    echo "Invalid JSON" >&2
    exit 1
fi
```

### Meaningful exit status ke liye `-e`

```bash
jq -e '.servers | length > 0' servers.json
echo $?
```

Aam tor par:

- Truthy final result: status `0`
- Final result `false` ya `null`: status `1`
- Parsing, compile ya usage problem: doosra nonzero status

```bash
if jq -e '.environment == "production"' servers.json >/dev/null; then
    echo "Production environment"
fi
```

---

## 20. Shell values safely pass karna

### `--arg` se string

```bash
required_status="running"

jq --arg status "$required_status" '
  .servers[]
  | select(.status == $status)
' servers.json
```

### `--argjson` se number ya JSON value

```bash
minimum_usage=50

jq --argjson minimum "$minimum_usage" '
  .servers[]
  | select(.usage > $minimum)
' servers.json
```

| Option | Value type |
|---|---|
| `--arg` | Hamesha JSON string pass karta hai |
| `--argjson` | Diye hue text ko JSON ke tor par parse karta hai |

Filters aam tor par single quotes mein hon. Single quotes shell ko JQ variables, parentheses, backslashes, wildcards aur pipes interpret karne se rokte hain.

---

## 21. Slurp mode aur raw input mode

Maan lein `events.jsonl` mein separate JSON objects hain:

```json
{"event":"login","user":"ali"}
{"event":"logout","user":"sara"}
{"event":"login","user":"khalid"}
```

### `-s` se ek array mein slurp karna

```bash
jq -s '.' events.jsonl
```

Records count karna:

```bash
jq -s 'length' events.jsonl
```

### `-R` se plain text parhna

```bash
printf '%s\n' web01 web02 db01 | jq -R '.'
```

### Lines se array banana

```bash
printf '%s\n' web01 web02 db01 |
jq -R -s 'split("\n") | map(select(length > 0))'
```

---

## 22. Command aur API output examples

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

Relevant commands installed aur authorized hon aur expected schema return karein.

---

## 23. Administrator reports aur output formats

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
| `@csv` | Array ko CSV banata hai |
| `@tsv` | Array ko tab-separated text banata hai |
| `@json` | Value ko JSON text mein encode karta hai |
| `@uri` | URI component percent-encode karta hai |
| `@base64` | Input ko Base64-encode karta hai |
| `@sh` | POSIX shell command line ke liye escape karta hai |

---

## 24. Transformed JSON safely save karna

Doosri file mein save karein:

```bash
jq '.environment = "staging"' servers.json > servers-new.json
```

Yeh use na karein:

```bash
jq '.environment = "staging"' servers.json > servers.json
```

Shell, JQ ke file parhne se pehle input ko empty kar sakta hai.

### Safe temporary-file workflow

```bash
jq '.environment = "staging"' servers.json > servers.tmp &&
mv servers.tmp servers.json
```

### Backup aur validation ke saath safer workflow

```bash
cp servers.json servers.json.bak

jq '.environment = "staging"' servers.json > servers.tmp &&
jq empty servers.tmp &&
mv servers.tmp servers.json
```

Yeh backup banata, temporary file generate karta, validate karta aur success ke baad original replace karta hai.

---

## 25. Sensitive data carefully handle karna

JSON output mein passwords, API tokens, access keys, private addresses ya personal data ho sakta hai.

Sensitive fields remove karein:

```bash
jq 'del(.password, .token, .secret)' response.json
```

Value mask karein:

```bash
jq '
  if has("token")
  then .token = "[REDACTED]"
  else .
  end
' response.json
```

Secrets ko terminal history, debug output, logs, screenshots ya shared reports mein expose na karein.

---

## 26. JQ aur text-processing tools

| Command | Main purpose |
|---|---|
| `grep` | Text lines search ya filter karta hai |
| `cut` | Simple delimited fields extract karta hai |
| `awk` | Text fields, conditions aur calculations process karta hai |
| `sed` | Text streams edit aur transform karta hai |
| `sort` | Text records arrange karta hai |
| `jq` | JSON parse, filter, transform aur format karta hai |

Fragile approach:

```bash
grep '"status"' servers.json
```

Structured approach:

```bash
jq '.servers[].status' servers.json
```

JQ nesting, arrays, strings, numbers, booleans, null, formatting changes aur valid JSON output samajhta hai.

---

## 27. Common mistakes

### Initial dot bhoolna

```bash
# Incorrect
jq 'servers' servers.json

# Correct
jq '.servers' servers.json
```

### Array iteration bhoolna

```bash
jq '.servers' servers.json
jq '.servers[]' servers.json
```

Pehli command array select karti hai; doosri har item process karti hai.

### Raw output bhoolna

```bash
jq -r '.servers[].name' servers.json
```

### Unsafe shell interpolation

Prefer karein:

```bash
jq --arg status "$status" '
  .servers[] | select(.status == $status)
' servers.json
```

### JQ aur shell pipes confuse karna

```bash
# JQ pipe quotes ke andar
jq '.servers[] | .name' servers.json

# Shell pipe quotes ke bahar
cat servers.json | jq '.servers[].name'
```

### Input directly overwrite karna

`jq ... file > file` use na karein; validated temporary file use karein.

### Numbers aur strings confuse karna

```bash
# String
jq --arg value "80" ...

# Number
jq --argjson value 80 ...
```

---

## 28. `jq` use karne se pehle thinking process

Yeh sawalat poochhein:

1. Kya input valid JSON hai?
2. Top-level value object hai ya array?
3. Required data kis path mein hai?
4. Ek value chahiye ya har array item?
5. Kya `select()` filtering chahiye?
6. Output JSON rehna chahiye ya raw text?
7. Kya sort, group, count ya calculation chahiye?
8. Missing ya null fields possible hain?
9. Kya sensitive data handle ho raha hai?
10. Result sirf display karna hai ya safely save bhi karna hai?

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

`servers.json` use karke yeh tasks complete karein:

1. Formatted JSON display karein.
2. Environment ko quotes ke baghair display karein.
3. Har server ka name display karein.
4. Running-server objects display karein.
5. Usage 50 se zyada wale names display karein.
6. Tamam servers count karein.
7. Running servers count karein.
8. Usage lowest se highest sort karein.
9. Highest-usage server display karein.
10. Server names ka array banayein.
11. Sirf name aur status wale objects banayein.
12. Name, status, usage aur IP ka CSV output banayein.
13. Generated output mein `web02` ko `stopped` se `maintenance` karein.
14. Generated output se tamam IP fields remove karein.
15. Total aur average usage calculate karein.
16. JSON ko output ke baghair validate karein.

### Solutions

```bash
# 1. Complete JSON format karna
jq '.' servers.json

# 2. Environment quotes ke baghair
jq -r '.environment' servers.json

# 3. Har server ka name
jq -r '.servers[].name' servers.json

# 4. Running servers
jq '.servers[] | select(.status == "running")' servers.json

# 5. Usage 50 se zyada wale names
jq -r '
  .servers[]
  | select(.usage > 50)
  | .name
' servers.json

# 6. Tamam servers count karna
jq '.servers | length' servers.json

# 7. Running servers count karna
jq '[.servers[] | select(.status == "running")] | length' servers.json

# 8. Usage ke mutabiq sort
jq '.servers | sort_by(.usage)' servers.json

# 9. Highest-usage server
jq '.servers | max_by(.usage)' servers.json

# 10. Names ka array
jq '.servers | map(.name)' servers.json

# 11. Name aur status objects
jq '.servers | map({name, status})' servers.json

# 12. CSV output
jq -r '.servers[] | [.name, .status, .usage, .ip] | @csv' servers.json

# 13. Generated output mein web02 status change karna
jq '
  .servers |= map(
    if .name == "web02"
    then .status = "maintenance"
    else .
    end
  )
' servers.json

# 14. IP fields remove karna
jq '.servers |= map(del(.ip))' servers.json

# 15. Total aur average usage
jq '
  [.servers[].usage]
  | {
      total: add,
      average: (if length > 0 then add / length else 0 end)
    }
' servers.json

# 16. Normal output ke baghair validate
jq empty servers.json
```

---

## 30. Quick knowledge check

1. `jq` kis type ka data process karta hai?
2. Identity filter `.` ka kya matlab hai?
3. `.servers` aur `.servers[]` mein kya farq hai?
4. `select()` kya karta hai?
5. `-r` kyun useful hai?
6. `-c` kya karta hai?
7. `map()` ka purpose kya hai?
8. `length`, `add`, `min_by()` aur `max_by()` kaise kaam karte hain?
9. `//` kya karta hai?
10. `--arg` aur `--argjson` mein kya farq hai?
11. `-s` aur `-R` kya karte hain?
12. Filters single quotes mein kyun hone chahiye?
13. JSON ko kaise validate karte hain?
14. Transformed output ke liye temporary file kyun use honi chahiye?
15. JSON ke liye `jq`, `grep` se behtar kyun hai?

---

## 31. Quick reference

```bash
# JSON format ya validate karna
jq '.' file.json

# Output ke baghair validate karna
jq empty file.json

# Ek field select karna
jq '.name' file.json

# Raw string output
jq -r '.name' file.json

# Har array item process karna
jq '.items[]' file.json

# Nested data select karna
jq '.items[0].name' file.json

# Records filter karna
jq '.items[] | select(.status == "running")' file.json

# Naya object banana
jq '.items[] | {name, status}' file.json

# Array banana
jq '[.items[].name]' file.json

# Har array item transform karna
jq '.items | map(.name)' file.json

# Items count karna
jq '.items | length' file.json

# Field ke mutabiq sort
jq '.items | sort_by(.usage)' file.json

# Maximum dhoondhna
jq '.items | max_by(.usage)' file.json

# Numbers ka total
jq '[.items[].usage] | add' file.json

# Default value
jq '.region // "unknown"' file.json

# Compact output
jq -c '.items[]' file.json

# Shell string pass karna
jq --arg value "$variable" '.key = $value' file.json

# JSON value pass karna
jq --argjson value "$number" '.key = $value' file.json

# Inputs ko array mein slurp karna
jq -s '.' records.jsonl

# Plain text lines parhna
jq -R '.' file.txt

# CSV output
jq -r '.items[] | [.name, .status] | @csv' file.json

# TSV output
jq -r '.items[] | [.name, .status] | @tsv' file.json
```

## Final summary

`jq` ek command-line JSON processor hai jo structured JSON data ko parse, filter, transform, calculate, sort aur format karta hai.

Yaad rakhein:

```text
grep = text lines search karna
cut  = simple text fields extract karna
awk  = text records aur fields process karna
sed  = text streams edit karna
sort = text records arrange karna
jq   = JSON parse aur transform karna
```
