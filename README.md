# 📘 JMeter Test Execution Guide with InfluxDB + Grafana Monitoring

## 🔧 Prerequisites

You should have the following:

- `TestPlan.jmx` — JMeter test plan  
- `Dataset.csv` — test data  
- Docker Compose file for `InfluxDB` and `Grafana`  
- Preconfigured Grafana Dashboard and DataSource  
- `StartTestPlan.bat` file to launch the test  
- Apache JMeter installed  

---

## 🧱 STEP 1: Launch InfluxDB and Grafana

1. Navigate to the directory containing your Docker Compose file:
   ```bash
   cd /path/to/your/docker-compose
   ```

2. Start the services in detached mode:
   ```bash
   docker compose up -d
   ```

   ![image](https://github.com/user-attachments/assets/6021cf92-21e6-4be1-9606-5f69292a1291)

3. Make sure `influxdb` and `grafana` containers are running:
   ```bash
   docker ps
   ```

---

## ⚙️ STEP 2: Run the Test

### 🔹 OPTION 1: Using JMeter GUI

1. Start JMeter:
   ```bash
   cd /path/to/apache-jmeter/bin
   jmeter.bat
   ```

2. Open your test plan:
   - **File** → **Open** → select `TestPlan.jmx`

3. Click the **Start** button (green arrow)

   ![image](https://github.com/user-attachments/assets/f2d06bff-97ab-4372-b832-edc9d86f081d)

4. Open Grafana in your browser:
   ```
   http://localhost:3000
   ```
   Log in with `admin` / `admin`  
   and open the metrics dashboard

   ![image](https://github.com/user-attachments/assets/2bdae964-136a-4018-900e-b8590efd37ca)

---

### 🔹 OPTION 2: Using `StartTestPlan.bat` file

#### 1. Edit `StartTestPlan.bat`

You need to set the path to your JMeter installation:

```bat
@echo off
REM Set the path to JMeter (replace with your actual path)
set JMETER_PATH=""
```

The test is launched using the command:
```bat
%JMETER_PATH%\jmeter.bat -n -t %TEST_PLAN% -l %RESULTS_FOLDER%\results.jtl -e -o %RESULTS_FOLDER%\dashboard
```

> 🔸 Parameters explained:  
> - `-n` — run in non-GUI mode  
> - `-t` — path to the JMX test plan  
> - `-l` — results output file (`.jtl`)  
> - `-e -o` — generate HTML dashboard in output folder  
> - `-j` — optional: path to the JMeter log file

#### 2. Run `StartTestPlan.bat`

Double-click it or run via terminal:

```bash
cd /path/to/batch-file
StartTestPlan.bat
```

#### 3. View metrics

Open your browser and go to:

```
http://localhost:3000
```

Log in with `admin` / `admin`  
Open the dashboard to see the test results

   ![image](https://github.com/user-attachments/assets/fd280a2d-4229-4de1-afab-10773c828d54)

---

## 🧹 Additional (Optional)

### Stop containers after test completion:

```bash
docker compose down -v
```

### View raw metrics in InfluxDB via CLI:

```bash
docker exec -it influxdb influx
```

---

## ✅ Expected Result

- `TestPlan.jmx` runs using data from `Dataset.csv`  
- Execution data is sent to InfluxDB via Backend Listener  
- Grafana automatically displays metrics on the dashboard  

---

## ⚠️ Possible Test Errors

During execution, some tests **may occasionally fail**. This is due to the behavior of the API at [https://petstore.swagger.io](https://petstore.swagger.io), which uses a **load balancer**.

As a result:
- Requests for creating, updating, or deleting users may hit different backend instances
- Data is **not synchronized instantly** between those instances
- For example, the test may create a user on one server, and then try to check or delete it on another, where the user does not yet (or no longer) exist

This leads to:
- Error responses like `User not found`, `User already exists`, etc.
- These are **not actual test failures**, but a known **limitation of the demo API**

> 🔍 To ensure consistent and predictable test results, consider using your own dedicated test environment with a single backend instance.
