# Weather Forecast Web Application

A simple and minimalist Java web application for checking weather forecasts using OpenWeatherMap API, TailwindCSS, and PostgreSQL database.

## Features

- 🌤️ Real-time weather data from OpenWeatherMap API
- 💾 PostgreSQL database for storing search history
- 🎨 Beautiful minimalist UI with TailwindCSS
- 📱 Responsive design for mobile and desktop
- 🔍 Search weather by city name
- 📊 View search history
- ⚡ Fast and lightweight

## Technologies Used

- **Backend**: Java Servlets, JSP
- **Frontend**: TailwindCSS, Font Awesome Icons
- **Database**: PostgreSQL
- **API**: OpenWeatherMap API
- **Build Tool**: Maven
- **Server**: Apache Tomcat (or any servlet container)

## Prerequisites

Before running this application, make sure you have:

1. **JDK 11 or higher** installed
2. **Apache Tomcat 9+** or any servlet container
3. **PostgreSQL 12+** installed and running
4. **Maven 3.6+** for building the project
5. **OpenWeatherMap API Key** (free at https://openweathermap.org/api)

## Setup Instructions

### 1. Database Setup

1. Create PostgreSQL database:
```sql
CREATE DATABASE weatherdb;
```

2. Run the schema script:
```bash
psql -U postgres -d weatherdb -f database/schema.sql
```

Or connect to PostgreSQL and run the SQL commands from `database/schema.sql`.

### 2. Configuration

1. Open `src/main/resources/config.properties`
2. Update the following properties:

```properties
# Database Configuration
db.url=jdbc:postgresql://localhost:5432/weatherdb
db.username=postgres
db.password=your_postgres_password

# OpenWeatherMap API Configuration
weather.api.key=your_api_key_here
weather.api.url=https://api.openweathermap.org/data/2.5/weather
```

3. Get your free API key from [OpenWeatherMap](https://openweathermap.org/api)

### 3. Build the Project

```bash
mvn clean package
```

This will create a WAR file in the `target` directory.

### 4. Deploy to Tomcat

**Option 1: Manual Deployment**
1. Copy `target/weatherforecast.war` to Tomcat's `webapps` directory
2. Start Tomcat
3. Access the application at `http://localhost:8080/weatherforecast`

**Option 2: Using Maven Tomcat Plugin**
Add this to your `pom.xml` (if not already present):
```xml
<plugin>
    <groupId>org.apache.tomcat.maven</groupId>
    <artifactId>tomcat7-maven-plugin</artifactId>
    <version>2.2</version>
    <configuration>
        <port>8080</port>
        <path>/weatherforecast</path>
    </configuration>
</plugin>
```

Then run:
```bash
mvn tomcat7:run
```

**Option 3: Using PowerShell Script**
Run the provided deployment script:
```powershell
.\deploy.ps1
```

## Application Structure

```
weatherforecast/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/weatherforecast/
│   │   │       ├── config/
│   │   │       │   └── DatabaseConfig.java
│   │   │       ├── dao/
│   │   │       │   └── WeatherDAO.java
│   │   │       ├── model/
│   │   │       │   └── Weather.java
│   │   │       ├── service/
│   │   │       │   └── WeatherService.java
│   │   │       └── servlet/
│   │   │           ├── WeatherServlet.java
│   │   │           └── SearchHistoryServlet.java
│   │   ├── resources/
│   │   │   └── config.properties
│   │   └── webapp/
│   │       ├── WEB-INF/
│   │       │   └── web.xml
│   │       ├── index.jsp
│   │       ├── weather-result.jsp
│   │       └── history.jsp
├── database/
│   └── schema.sql
├── pom.xml
└── README.md
```

## Usage

1. **Search Weather**: Enter a city name on the home page and click "Get Weather"
2. **View Results**: See detailed weather information including temperature, humidity, wind speed, and pressure
3. **Check History**: Click "View Search History" to see your previous searches stored in the database

## API Endpoints

- `GET /weatherforecast/` - Home page (search form)
- `GET /weatherforecast/weather?city={cityName}` - Get weather data for a city
- `GET /weatherforecast/history` - View search history

## Database Schema

The application uses a single table `weather_history`:

| Column | Type | Description |
|--------|------|-------------|
| id | SERIAL | Primary key |
| city | VARCHAR(100) | City name |
| country | VARCHAR(10) | Country code |
| temperature | DECIMAL(5,2) | Current temperature in Celsius |
| feels_like | DECIMAL(5,2) | Feels like temperature |
| humidity | INTEGER | Humidity percentage |
| wind_speed | DECIMAL(5,2) | Wind speed in m/s |
| description | VARCHAR(255) | Weather description |
| icon | VARCHAR(10) | Weather icon code |
| pressure | INTEGER | Atmospheric pressure in hPa |
| searched_at | TIMESTAMP | When the search was made |

## Design Features

- **Minimalist Design**: Clean and simple UI without clutter
- **Weather Icons**: Font Awesome icons (no emoji) for better aesthetics
- **Glass Morphism**: Modern glass effect for cards
- **Gradient Background**: Purple gradient background for weather theme
- **Responsive Layout**: Works on mobile, tablet, and desktop
- **Smooth Animations**: Hover effects and transitions

## Troubleshooting

### Database Connection Issues
- Verify PostgreSQL is running
- Check database credentials in `config.properties`
- Ensure database `weatherdb` exists

### API Errors
- Verify your API key is correct
- Check internet connection
- Free tier has rate limits (60 calls/minute)

### Build Errors
- Ensure JDK 11+ is installed
- Run `mvn clean install` to refresh dependencies
- Check Maven version: `mvn -version`

## License

This project is created for educational purposes.

## Credits

- Weather data: [OpenWeatherMap](https://openweathermap.org/)
- Icons: [Font Awesome](https://fontawesome.com/)
- CSS Framework: [TailwindCSS](https://tailwindcss.com/)

## Author

Created for College Task - Object-Oriented Programming (PBO)
