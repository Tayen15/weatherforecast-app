package com.weatherforecast.servlet;

import com.weatherforecast.dao.UserDAO;
import com.weatherforecast.model.User;
import org.mindrot.jbcrypt.BCrypt;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class UserServlet extends HttpServlet {
     private UserDAO userDAO;

     @Override
     public void init() throws ServletException {
          userDAO = new UserDAO();
     }

     @Override
     protected void doGet(HttpServletRequest request, HttpServletResponse response)
               throws ServletException, IOException {
          // Show register page
          request.getRequestDispatcher("/register.jsp").forward(request, response);
     }

     @Override
     protected void doPost(HttpServletRequest request, HttpServletResponse response)
               throws ServletException, IOException {
          String username = request.getParameter("username");
          String email = request.getParameter("email");
          String password = request.getParameter("password");

          // Validate email format
          if (email == null || !email.matches("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$")) {
               request.setAttribute("error", "Please enter a valid email address.");
               request.getRequestDispatcher("/register.jsp").forward(request, response);
               return;
          }

          // Validate password length
          if (password == null || password.length() < 6) {
               request.setAttribute("error", "Password must be at least 6 characters long.");
               request.getRequestDispatcher("/register.jsp").forward(request, response);
               return;
          }

          // Hash password using BCrypt
          String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

          User user = new User(username, email, hashedPassword);
          boolean success = userDAO.registerUser(user);

          if (success) {
               // Auto-login after successful registration
               HttpSession session = request.getSession();
               session.setAttribute("loggedInUser", username);
               session.setAttribute("userId", username); // For cookie compatibility

               // Redirect to home page
               response.sendRedirect(request.getContextPath() + "/");
          } else {
               request.setAttribute("error", "Registration failed. Username or email might be taken.");
               request.getRequestDispatcher("/register.jsp").forward(request, response);
          }
     }
}
