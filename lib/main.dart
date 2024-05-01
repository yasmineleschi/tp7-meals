import 'package:flutter/material.dart';
import 'package:tp7_navigation_screen/screens/CategoryMealsScreen.dart';
import 'package:tp7_navigation_screen/screens/FiltersScreen.dart';
import 'package:tp7_navigation_screen/screens/MealDetailScreen.dart';
import 'package:tp7_navigation_screen/screens/TabsScreen.dart';

import './dummy_data.dart';
import './models/meal.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, bool> _filters = {
    'gluten': false,
    'vegetarian': false,
    'vegan': false,
    'lactose': false,
  };

  List<Meal> _availableMeals = DUMMY_MEALS;

  List<Meal> _favoriteMeals = [];

  void _setFilters(Map<String, bool> filterData) {
    setState(() {
      _filters = filterData;

      _availableMeals = DUMMY_MEALS.where((meal) {
        if (_filters['gluten']! && !meal.isGlutenFree) {
          return false;
        }
        if (_filters['vegetarian']! && !meal.isVegetarian) {
          return false;
        }
        if (_filters['vegan']! && !meal.isVegan) {
          return false;
        }
        if (_filters['lactose']! && !meal.isLactoseFree) {
          return false;
        }
        return true;
      }).toList();
    });
  }

  void _toggleFavorite(String mealId) {
    final existingIndex =
    _favoriteMeals.indexWhere((meal) => meal.id == mealId);

    if (existingIndex >= 0) {
      setState(() {
        _favoriteMeals.removeAt(existingIndex);
      });
    } else {
      setState(() {
        _favoriteMeals.add(DUMMY_MEALS.firstWhere((meal) => meal.id == mealId));
      });
    }
  }

  bool _isMealFavorite(String mealId) {
    return _favoriteMeals.any((meal) => meal.id == mealId);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DeliMeals',
      theme: ThemeData(
        primarySwatch: MaterialColor(0xFFFC4100, {
          50: Color(0xFFFFCBB9),
          100: Color(0xFFFFB08A),
          200: Color(0xFFFF9360),
          300: Color(0xFFFF752F),
          400: Color(0xFFFF5B00),
          500: Color(0xFFFC4100), // Set primary color
          600: Color(0xFFFC4100),
          700: Color(0xFFFC4100),
          800: Color(0xFFFC4100),
          900: Color(0xFFFC4100),
        }),
        primaryColor: Color(0xFF00215E),
        canvasColor: Color.fromRGBO(255, 254, 229, 1),
        fontFamily: 'Raleway',
        textTheme: TextTheme(
          bodyText1: TextStyle(
            color: Color(0xFFFFC55A),
          ),
          bodyText2: TextStyle(
            color: Color(0xFFFFC55A),
          ),
          headline6: TextStyle(
            fontSize: 20,
            fontFamily: 'RobotoCondensed',
            fontWeight: FontWeight.bold,
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: Color(0xFF00215E),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF00215E),
          iconTheme: IconThemeData(color: Color(0xFFFFC55A)),
          centerTitle: true, toolbarTextStyle: TextTheme(
            headline6: TextStyle(color: Color(0xFFFFC55A)),
            headline6: TextStyle(color: Color(0xFFFFC55A)),
          ).headline6,
        ),
      ),

      initialRoute: '/',
      routes: {
        '/': (ctx) => TabsScreen(_favoriteMeals),
        CategoryMealsScreen.routeName: (ctx) =>
            CategoryMealsScreen(_availableMeals),
        MealDetailScreen.routeName: (ctx) =>
            MealDetailScreen(_toggleFavorite, _isMealFavorite),
        FiltersScreen.routeName: (ctx) => FiltersScreen(_filters, _setFilters),
      },


    /* onGenerateRoute: (settings) {
        //if(settings.name == 'meal-detail') { return ...; }
        return MaterialPageRoute(builder: (ctx) => CategoriesScreen());
      }, */
      /* onUnknownRoute: (settings){
        return MaterialPageRoute(builder: (ctx) => CategoriesScreen());
      }, */
    );
  }
}