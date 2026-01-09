# Weather Forecast Web Application

A comprehensive Java web application for checking weather forecasts with user management, news system, and personalized features using OpenWeatherMap API, TailwindCSS, and PostgreSQL database.

## Features

- 🌤️ Real-time weather data from OpenWeatherMap API
- 👤 User authentication and registration system with BCrypt password hashing
- 📰 News management system with admin panel
- ❤️ Save favorite locations for quick access
- 💾 PostgreSQL database for storing user data, weather history, and news
- 🎨 Beautiful modern UI with TailwindCSS and dark theme
- 📱 Responsive design for mobile and desktop
- 🔍 Search weather by city name with detailed forecast
- 📊 View personal search history
- 🔐 Role-based access control (Admin/User)
- 🛠️ Admin dashboard for managing news content
- ⚡ Fast and lightweight with custom toast notifications

## Technologies Used

- **Backend**: Java Servlets, JSP
- **Frontend**: TailwindCSS, Font Awesome Icons, TinyMCE Editor
- **Database**: PostgreSQL with connection pooling
- **Authentication**: BCrypt password hashing
- **API**: OpenWeatherMap API
- **Build Tool**: Maven
- **Server**: Apache Tomcat 8.5+

## Prerequisites

Before running this application, make sure you have:

1. **JDK 17 or higher** installed
2. **Apache Tomcat 8.5+** or any servlet container
3. **PostgreSQL 12+** installed and running
4. **Maven 3.6+** for building the project
5. **OpenWeatherMap API Key** (free at https://openweathermap.org/api)
6. **TinyMCE API Key** (free at https://www.tiny.cloud/) - for rich text editor

## Setup Instructions

### 1. Database Setup

1. Create PostgreSQL database:
```sql
CREATE DATABASE weatherdb;
```

2. Run the schema script to create tables:
```bash
psql -U postgres -d weatherdb -f database/schema.sql
```

3. (Optional) Load sample data including admin user:
```bash
psql -U postgres -d weatherdb -f database/sample-data.sql
```

**Default Admin Credentials (from sample data):**
- Username: `admin`
- Password: `123456`

Or connect to PostgreSQL and run the SQL commands from the schema files manually.

### 2. Configuration

1. Copy the example config file:
```bash
cp src/main/resources/config.properties.example src/main/resources/config.properties
```

2. Open `src/main/resources/config.properties` and update the following:

```properties
# Database Configuration
db.url=jdbc:postgresql://localhost:5432/weatherdb
db.username=postgres
db.password=your_postgres_password

# OpenWeatherMap API Configuration
weather.api.key=your_openweathermap_api_key_here
weather.api.url=https://api.openweathermap.org/data/2.5/weather
```

3. Get your free API keys:
   - OpenWeatherMap: [https://openweathermap.org/api](https://openweathermap.org/api)
   - TinyMCE (for admin panel): [https://www.tiny.cloud/](https://www.tiny.cloud/)

4. Update TinyMCE API key in `src/main/webapp/admin/news-management.jsp`:
```javascript
<script src="https://cdn.tiny.cloud/1/YOUR_API_KEY/tinymce/6/tinymce.min.js"></script>
```

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
│   │   │       │   └── DatabaseConfig.java      # Database connection management
│   │   │       ├── dao/
│   │   │       │   ├── WeatherDAO.java          # Weather history data access
│   │   │       │   ├── UserDAO.java             # User authentication data access
│   │   │       │   ├── FavoriteLocationDAO.java # Favorite locations management
│   │   │       │   └── NewsDAO.java             # News content management
│   │   │       ├── filter/
│   │   │       │   └── AdminFilter.java         # Admin access control filter
│   │   │       ├── model/
│   │   │       │   ├── Weather.java             # Weather data model
│   │   │       │   ├── User.java                # User entity model
│   │   │       │   ├── FavoriteLocation.java    # Favorite location model
│   │   │       │   ├── News.java                # News article model
│   │   │       │   ├── DailyForecast.java       # Daily forecast model
│   │   │       │   └── HourlyForecast.java      # Hourly forecast model
│   │   │       ├── service/
│   │   │       │   └── WeatherService.java      # Weather API integration
│   │   │       └── servlet/
│   │   │           ├── WeatherServlet.java      # Main weather search
│   │   │           ├── WeatherApiServlet.java   # REST API endpoint
│   │   │           ├── SearchHistoryServlet.java # Search history viewer
│   │   │           ├── LoginServlet.java        # User login
│   │   │           ├── LogoutServlet.java       # User logout
│   │   │           ├── UserServlet.java         # User registration
│   │   │           ├── FavoriteServlet.java     # Favorites management
│   │   │           ├── NewsServlet.java         # Public news viewer
│   │   │           └── AdminNewsServlet.java    # Admin news CRUD
│   │   ├── resources/
│   │   │   ├── config.properties               # App configuration
│   │   │   └── config.properties.example       # Config template
│   │   └── webapp/
│   │       ├── admin/
│   │       │   └── news-management.jsp         # Admin dashboard
│   │       ├── includes/
│   │       │   ├── navbar.jsp                  # Navigation bar
│   │       │   └── footer.jsp                  # Footer
│   │       ├── WEB-INF/
│   │       │   └── web.xml                     # Servlet configuration
│   │       ├── index.jsp                       # Home page
│   │       ├── weather-result.jsp              # Weather results
│   │       ├── history.jsp                     # Search history
│   │       ├── login.jsp                       # Login page
│   │       ├── register.jsp                    # Registration page
│   │       ├── favorites.jsp                   # Favorite locations
│   │       ├── about.jsp                       # About page
│   │       ├── news.jsp                        # News listing
│   │       └── news-detail.jsp                 # News article detail
├── database/
│   ├── schema.sql                              # Database schema
│   └── sample-data.sql                         # Sample data with admin user
├── deploy.ps1                                  # PowerShell deployment script
├── pom.xml                                     # Maven configuration
└── README.md
```

## Usage

### For Regular Users

1. **Register Account**: Create a new account from the registration page
2. **Login**: Sign in with your credentials
3. **Search Weather**: Enter a city name on the home page and click "Get Weather"
4. **View Results**: See detailed weather information including temperature, humidity, wind speed, and pressure
5. **Save Favorites**: Click heart icon to save locations for quick access
6. **Check History**: View your previous searches stored in the database
7. **Read News**: Browse weather-related news articles

### For Administrators

1. **Login as Admin**: Use admin credentials to access admin features
2. **Access Admin Panel**: Click "Admin" in navigation menu
3. **Manage News**: Create, edit, publish, or delete news articles
4. **Rich Text Editor**: Use TinyMCE for formatting news content
5. **View Analytics**: Monitor news publication status

## User Roles

### User (Regular)
- Search weather forecasts
- Save favorite locations
- View search history
- Read published news articles
- Manage personal account

### Admin
- All user features
- Access admin dashboard
- Create/edit/delete news articles
- Publish/unpublish news
- Manage content with rich text editor

## API Endpoints

### Public Endpoints
- `GET /` - Home page (weather search)
- `GET /weather?city={cityName}` - Get weather data for a city
- `GET /login.jsp` - Login page
- `GET /register` - User registration
- `GET /news` - News listing page
- `GET /news?id={newsId}` - News article detail
- `GET /news?ajax=true&limit=3` - Get latest news (JSON)
- `GET /about.jsp` - About page

### Protected Endpoints (Requires Login)
- `GET /history` - View personal search history
- `GET /favorites` - View saved favorite locations
- `POST /favorites` - Add/remove favorite location
- `GET /logout` - User logout

### Admin Endpoints (Requires Admin Role)
- `GET /admin/news` - Admin news management dashboard
- `GET /admin/news?action=list` - Get all news (JSON)
- `GET /admin/news?action=get&id={newsId}` - Get news by ID (JSON)
- `POST /admin/news` - Create/update/delete/publish news (JSON)

## Database Schema

The application uses multiple tables:

### `users` - User accounts
| Column | Type | Description |
|--------|------|-------------|
| username | VARCHAR(50) | Primary key, unique username |
| email | VARCHAR(100) | Unique email address |
| password_hash | VARCHAR(255) | BCrypt hashed password |
| full_name | VARCHAR(100) | User's full name |
| role | VARCHAR(20) | User role (admin/user) |
| created_at | TIMESTAMP | Registration timestamp |

### `weather_history` - Search history
| Column | Type | Description |
|--------|------|-------------|
| id | SERIAL | Primary key |
| username | VARCHAR(50) | Foreign key to users |
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

### `favorite_locations` - Saved favorites
| Column | Type | Description |
|--------|------|-------------|
| id | SERIAL | Primary key |
| username | VARCHAR(50) | Foreign key to users |
| city | VARCHAR(100) | City name |
| country | VARCHAR(100) | Country name |
| added_at | TIMESTAMP | When location was saved |

### `news` - News articles
| Column | Type | Description |
|--------|------|-------------|
| id | SERIAL | Primary key |
| title | VARCHAR(255) | Article title |
| content | TEXT | Article content (HTML) |
| author | VARCHAR(100) | Author name |
| image_url | VARCHAR(500) | Optional image URL |
| is_published | BOOLEAN | Publication status |
| created_at | TIMESTAMP | Creation timestamp |
| updated_at | TIMESTAMP | Last update timestamp |

## Design Features

- **Dark Modern Theme**: Professional dark gradient background with light accents
- **Responsive Layout**: Optimized for mobile, tablet, and desktop devices
- **Glass Morphism**: Modern glass effect for cards and modals
- **Custom Toast Notifications**: Elegant animated notifications instead of browser alerts
- **Rich Text Editor**: TinyMCE integration for news content formatting
- **Weather Icons**: Font Awesome icons for consistent design
- **Smooth Animations**: Hover effects, transitions, and loading states
- **Role-Based UI**: Dynamic navigation based on user authentication and role
- **Modal Dialogs**: Beautiful confirmation and form modals
- **Accessible Design**: Proper form labels and semantic HTML

## Troubleshooting

### Database Connection Issues
- Verify PostgreSQL is running on port 5432
- Check database credentials in `config.properties`
- Ensure database `weatherdb` exists
- Verify all tables are created using `schema.sql`
- Check PostgreSQL logs for connection errors

### Authentication Issues
- Ensure `users` table exists in database
- Verify BCrypt library is included in dependencies
- Check session timeout settings in `web.xml`
- Clear browser cookies if login fails repeatedly
- Use sample data admin credentials: `admin` / `123456`

### API Errors
- Verify your OpenWeatherMap API key is correct and active
- Check internet connection
- Free tier has rate limits (60 calls/minute)
- Check API response in browser console for error details

### Admin Panel Issues
- Ensure user has `admin` role in database
- Verify AdminFilter is properly configured
- Check TinyMCE API key is valid
- Clear browser cache and Tomcat work directory
- Check servlet mappings in `web.xml`

### Build Errors
- Ensure JDK 17+ is installed (`java -version`)
- Run `mvn clean install` to refresh dependencies
- Check Maven version: `mvn -version`
- Delete `target/` directory and rebuild
- Verify all dependencies in `pom.xml` are accessible

### Deployment Issues
- Stop Tomcat before deployment
- Delete old `webapps/weatherforecast` folder
- Remove Tomcat work cache: `work/Catalina/localhost/weatherforecast`
- Check Tomcat logs: `logs/catalina.out`
- Ensure no servlet mapping conflicts in `web.xml`

## Security Features

- **Password Hashing**: BCrypt with salt for secure password storage
- **Session Management**: Servlet session-based authentication
- **Role-Based Access Control**: Admin filter protects sensitive endpoints
- **SQL Injection Prevention**: Prepared statements in all DAO classes
- **XSS Protection**: HTML escaping in JSP pages
- **AJAX Security**: Proper JSON error handling for session expiration
- **CSRF Protection**: Same-origin credentials for AJAX requests

## Credits

- Weather data: [OpenWeatherMap](https://openweathermap.org/)
- Icons: [Font Awesome](https://fontawesome.com/)
- CSS Framework: [TailwindCSS](https://tailwindcss.com/)
- Rich Text Editor: [TinyMCE](https://www.tiny.cloud/)
- Password Hashing: [jBCrypt](https://github.com/jeremyh/jBCrypt)
- JSON Processing: [Gson](https://github.com/google/gson)

## License

This project is created for educational purposes as part of Object-Oriented Programming (PBO) college coursework.

## Author

Created for College Task - Object-Oriented Programming (PBO)

## Support

For issues, questions, or contributions, please refer to the course instructor or teaching assistant.
