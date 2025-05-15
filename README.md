# 📘 Інструкція запуску JMeter тесту з моніторингом через InfluxDB + Grafana

## 🔧 Попередні умови

- Наявні:
  - `TestPlan.jmx` — тестовий план
  - `Dataset.csv` — тестові дані
  - Docker Compose файл для `InfluxDB` та `Grafana`
  - Налаштований Grafana Dashboard та DataSource
  - `StartTestPlan.bat` файл для запуску тесту
  - Встановлений Apache JMeter

---

## 🧱 КРОК 1: Запуск InfluxDB та Grafana

1. Перейдіть у директорію з Docker Compose:
   ```bash
   cd /шлях/до/вашого/docker-compose
   ```

2. Запустіть сервіси у фоновому режимі:
   ```bash
   docker compose up -d
   ```

   ![image](https://github.com/user-attachments/assets/6021cf92-21e6-4be1-9606-5f69292a1291)


3. Перевірте, що `influxdb` і `grafana` запущені:
   ```bash
   docker ps
   ```

---

## ⚙️ КРОК 2: Запуск тесту

### 🔹 ВАРІАНТ 1: Через інтерфейс JMeter

1. Запустіть JMeter:
   ```bash
   cd /шлях/до/apache-jmeter/bin
   jmeter.bat
   ```

2. Відкрийте тестовий план:
   - **File** → **Open** → виберіть `TestPlan.jmx`

3. Натисніть кнопку **Start** (зелена стрілка)

   ![image](https://github.com/user-attachments/assets/f2d06bff-97ab-4372-b832-edc9d86f081d)

4. Перейдіть у браузері на:
   ```
   http://localhost:3000
   ```
   
   Авторизуйтесь через admin/admin
   і відкрийте дашборд з метриками

   ![image](https://github.com/user-attachments/assets/2bdae964-136a-4018-900e-b8590efd37ca)

---

### 🔹 ВАРІАНТ 2: Через `StartTestPlan.bat` файл

#### 1. Відредагуйте `StartTestPlan.bat` файл

У файлі потрібно вказати шлях до JMeter:

```bat
@echo off
REM Встановіть шлях до JMeter (зміні на свій)
set JMETER_PATH=""
```

Запуск відбувається командою:
```bat
%JMETER_PATH%\jmeter.bat -n -t %TEST_PLAN% -l %RESULTS_FOLDER%\results.jtl -e -o %RESULTS_FOLDER%\dashboard
```

> 🔸 Пояснення параметрів:
> - `-n` — запуск у non-GUI режимі
> - `-t` — шлях до JMX тестового плану
> - `-l` — файл для запису результатів (`.jtl`)
> - `-j` — лог-файл JMeter

#### 2. Запустіть `StartTestPlan.bat` файл

Подвійним кліком або через термінал:

```bash
cd /шлях/до/бат-файлу
run_test.bat
```

#### 3. Перегляньте метрики

Перейдіть у браузері на:

```
http://localhost:3000
```

Авторизуйтесь через admin/admin
Відкрийте дашборд, щоб переглянути результати тестування.

   ![image](https://github.com/user-attachments/assets/fd280a2d-4229-4de1-afab-10773c828d54)

---

## 🧹 Додатково (опціонально)

### Зупинка контейнерів після тестування:

```bash
docker compose down -v
```

### Перевірка метрик безпосередньо в InfluxDB (через CLI):

```bash
docker exec -it influxdb influx
```

---

## ✅ Очікуваний результат

- Тестовий план `TestPlan.jmx` виконується з використанням `Dataset.csv`
- Дані про виконання передаються в InfluxDB через Backend Listener
- Grafana автоматично відображає метрики на дашборді
