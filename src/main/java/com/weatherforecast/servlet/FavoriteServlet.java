package com.weatherforecast.servlet;

import com.weatherforecast.dao.FavoriteLocationDAO;
import com.weatherforecast.model.FavoriteLocation;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

public class FavoriteServlet extends HttpServlet {
     private FavoriteLocationDAO favoriteDAO;

     @Override
     public void init() throws ServletException {
          favoriteDAO = new FavoriteLocationDAO();
     }

     @Override
     protected void doGet(HttpServletRequest request, HttpServletResponse response)
               throws ServletException, IOException {
          // Check if user is logged in
          HttpSession session = request.getSession(false);
          if (session == null || session.getAttribute("loggedInUser") == null) {
               // Not logged in, redirect to login page with message
               request.setAttribute("message", "Please login to view your favorite locations.");
               request.getRequestDispatcher("/login.jsp").forward(request, response);
               return;
          }

          String username = (String) session.getAttribute("loggedInUser");
          List<FavoriteLocation> favorites = favoriteDAO.getFavoritesByUser(username);

          request.setAttribute("favorites", favorites);
          request.getRequestDispatcher("/favorites.jsp").forward(request, response);
     }

     @Override
     protected void doPost(HttpServletRequest request, HttpServletResponse response)
               throws ServletException, IOException {
          // Check if user is logged in
          HttpSession session = request.getSession(false);
          if (session == null || session.getAttribute("loggedInUser") == null) {
               // Not logged in, redirect to login page
               response.sendRedirect(request.getContextPath() + "/login");
               return;
          }

          String username = (String) session.getAttribute("loggedInUser");
          String action = request.getParameter("action");

          if ("add".equals(action)) {
               String city = request.getParameter("city");
               String country = request.getParameter("country");

               FavoriteLocation fav = new FavoriteLocation(username, city, country, "Saved from search");
               favoriteDAO.addFavorite(fav);

               // Redirect back to the weather result page
               response.sendRedirect(request.getContextPath() + "/weather?city=" + city);
          } else if ("delete".equals(action)) {
               int id = Integer.parseInt(request.getParameter("id"));
               boolean success = favoriteDAO.removeFavorite(id);

               if (success) {
                    session.setAttribute("successMessage", "Location removed from favorites.");
               } else {
                    session.setAttribute("errorMessage", "Failed to remove location. Please try again.");
               }
               response.sendRedirect(request.getContextPath() + "/favorites");
          }
     }
}
