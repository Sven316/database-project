import flask
from flask import Flask, render_template, request, jsonify, url_for
from collections import defaultdict
import pymysql
from array import array

# Prompt user for mysql username and password
username = input('MySQL Username: ')
password = input('MySQL Password: ')
# username = 'root'
# password = 'A14307110294z'

# Connect to DB
try:
    db = pymysql.connect(host='localhost', user=username, password=password, db='city_evaluation', charset='utf8mb4', cursorclass=pymysql.cursors.DictCursor, autocommit=True)
    
    print ('Connected to database!')

except pymysql.err.OperationalError as e:
    print('Error: %d: %s' % (e.args[0], e.args[1]))


try:
    # init cursors
    cursor1 = db.cursor()
    cursor2 = db.cursor()
    cursor3 = db.cursor()
    cursor4 = db.cursor()
    cursor5 = db.cursor()
    cursor6 = db.cursor()
    filterCursor = db.cursor()
    profileCursor = db.cursor()
    cityCursor = db.cursor()

    # declare app
    app = Flask(__name__, instance_relative_config=True)

    # Get all continent names
    def getContinents():
        continents_stmt = 'SELECT DISTINCT continent FROM country order by continent'
        cursor1.execute(continents_stmt)
        continents = cursor1.fetchall()        
        continent_names = []
        for row in continents:
            continent_names.append(row['continent'])

        return continent_names

    # Get all country names
    def getCountries():
        countries_stmt = 'SELECT DISTINCT country_name FROM country order by country_name'
        cursor2.execute(countries_stmt)
        countries = cursor2.fetchall()
        country_names = []
        for row in countries:
            country_names.append(row['country_name'])

        return country_names

    # Get all distinct climates
    def getClimates():
        climates_stmt = 'SELECT DISTINCT climate_type FROM climate ORDER BY climate_type'
        cursor3.execute(climates_stmt)
        climates = cursor3.fetchall()
        
        climate_names = []
        for row in climates:
            climate_names.append(row['climate_type'])

        return climate_names

    # Get all distinct topographys
    def getTopography():
        topography_stmt = 'SELECT DISTINCT topography_id FROM topography ORDER BY topography_id'
        cursor4.execute(topography_stmt)
        topographys = cursor4.fetchall()
        
        topography_ids = []
        for row in topographys:
            topography_ids.append(row['topography_id'])

        return topography_ids

    # Get all city names
    def getCityNames():
        names_stmt = 'SELECT city_name FROM city ORDER BY city_name'
        cursor5.execute(names_stmt)
        names = cursor5.fetchall()
        
        city_names = []
        for row in names:
            city_names.append(row['city_name'])

        return city_names

    # Get city info
    def getCityInfo(city_id):
        stmt = 'SELECT * FROM city WHERE city_id = ' + str(city_id)
        cursor6.execute(stmt)
        result = cursor6.fetchall()
        
        info = result[0].values()
        
        return list(info)


    # index page (homepage) =======================================================
    @app.route('/')
    def db():
        continents = getContinents()
        countries = getCountries()
        climates = getClimates()
        topographys = getTopography()

        return render_template('index.html', continents=continents, countries=countries, climates=climates, topographys=topographys)


    # Filter results view =========================================================
    # Route for the 'Filter' button on the nav page
    @app.route('/filter', methods=['GET', 'POST'])
    def filter():
        continent = str(request.form.get('continent'))
        country_name = str(request.form.get('country'))
        climate_type = str(request.form.get('climate'))
        topography_id = str(request.form.get('topography'))

        filterItems = [continent, country_name, climate_type, topography_id]

        params = []
        for item in filterItems:
            if 'All' in item:
                item = ''
                params.append(item)
            else:
                params.append(item)

        results = filterCity( params )

        return render_template('filter.html', filterItems=filterItems, results=results)


    def filterCity( params ):
        continent = params[0]
        country_name = params[1]
        climate_type = params[2]
        topography_id = params[3]
        headers = ['country_name = ', ' climate_type = ', ' topography_id = ']
        allEmpty = ((continent == '') and (country_name == '') and (climate_type == '') and (topography_id == ''))

        # return all 500 attractions if no dropdowns changed
        if allEmpty == True:
            stmt = "SELECT * FROM city"
            filterCursor.execute(stmt)
            results = filterCursor.fetchall()
            all_results = []
            for row in results:
                values = list(row.values())
                all_results.append(values)

            return all_results

        else:
            if continent == '':
                conditions = ''
                i = 0
                for col in params[-3:]:
                    if col != '':
                        conditions += headers[i]
                        conditions += '"' + col + '"'
                        conditions += ' AND'
                    i += 1

                stmt = "SELECT * FROM city WHERE "
                cond = conditions[:-4]
                orderby = " ORDER BY city_id"

            else:
                conditions = ''
                i = 0
                for col in params[-3:]:
                    if col != '':
                        conditions += headers[i]
                        conditions += '"' + col + '"'
                        conditions += ' AND'
                    i += 1
                stmt = "SELECT * FROM city WHERE "
                cond = conditions + " country_name IN (SELECT country_name FROM country WHERE continent = '" + continent + "')"
                orderby = " ORDER BY city_id"

            # concat strings to create full select statement based on user inputs
            select_stmt = stmt + cond + orderby
            filterCursor.execute(select_stmt)
            results = filterCursor.fetchall()
            result_arr = []
            for row in results:
                values = list(row.values())
                result_arr.append(values)

            return result_arr

    ###############################################################################
    # CITIES
    ###############################################################################

    # Create a city page =========================================================
    # Route for the 'Create A City' nav link
    @app.route('/city')
    def city():
        countries = getCountries()
        climates = getClimates()
        topographys = getTopography()

        return render_template('new.html', countries=countries, climates=climates, topographys=topographys)


    # Get a city based on city_id
    def getCity(city_id):
        stmt = 'SELECT * FROM city WHERE city_id = ' + city_id
        profileCursor.execute(stmt)
        results = profileCursor.fetchall()
        cities = []
        for row in results:
            values = row.values()
            cities.append(values)

        return list(cities[0])


    # City profile ============================================================
    # Route for the 'Your City ID' nav link
    @app.route('/profile/<city_id>')
    def cityProfile(city_id):
        cityInfo = getCity(city_id)

        city_id = cityInfo[0]
        city_name = cityInfo[1]
        cost_of_living_index = cityInfo[2]
        rent_index = cityInfo[3]
        general_cost_index = cityInfo[4]
        groceries_index = cityInfo[5]
        restaurant_price_index = cityInfo[6]
        local_purchasing_power_index = cityInfo[7]
        country_name = cityInfo[8]
        topography_id = cityInfo[9]
        climate_type = cityInfo[10]

        countries = getCountries()
        climates = getClimates()
        topographys = getTopography()

        return render_template("profile.html", city_id = city_id, city_name = city_name, cost_of_living_index = cost_of_living_index, rent_index = rent_index, general_cost_index = general_cost_index, groceries_index = groceries_index,
        restaurant_price_index = restaurant_price_index, local_purchasing_power_index = local_purchasing_power_index, country_name = country_name, topography_id = topography_id, climate_type = climate_type, countries=countries, climates=climates, topographys=topographys)

    # New city profile =========================================================
    @app.route('/profile', methods=['GET', 'POST'])
    def createCity():
    
        city_name = str(request.form.get('city_name'))
        cost_of_living_index = str(request.form.get('cost_of_living_index'))
        rent_index = str(request.form.get('rent_index'))
        general_cost_index = str(request.form.get('general_cost_index'))
        groceries_index = str(request.form.get('groceries_index'))
        restaurant_price_index = str(request.form.get('restaurant_price_index'))
        local_purchasing_power_index = str(request.form.get('local_purchasing_power_index'))
        country_name = str(request.form.get('country_name'))
        topography_id = str(request.form.get('topography_id'))
        climate_type = str(request.form.get('climate_type'))

        # Call new_city procedure
        sql = "CALL new_city('"+ city_name +"', '"+ cost_of_living_index +"', '"+ rent_index +"', '"+ general_cost_index +"', '"+ groceries_index +"', '"+ restaurant_price_index +"', '"+ local_purchasing_power_index +"', '"+ country_name +"', '"+ topography_id +"', '"+ climate_type +"')"
        cityCursor.execute(sql)
        results = cityCursor.fetchall()
        cityIDs = []
        for row in results:
            cityIDs.append(row['your_id'])

        city_id = str(cityIDs[0])

        cityInfo = getCity(city_id)

        # city_id = cityInfo[0]
        city_name = cityInfo[1]
        cost_of_living_index = cityInfo[2]
        rent_index = cityInfo[3]
        general_cost_index = cityInfo[4]
        groceries_index = cityInfo[5]
        restaurant_price_index = cityInfo[6]
        local_purchasing_power_index = cityInfo[7]
        country_name = cityInfo[8]
        topography_id = cityInfo[9]
        climate_type = cityInfo[10]

        countries = getCountries()
        climates = getClimates()
        topographys = getTopography()

        return render_template("profile.html", city_id = city_id, city_name = city_name, cost_of_living_index = cost_of_living_index, rent_index = rent_index, general_cost_index = general_cost_index, groceries_index = groceries_index,
        restaurant_price_index = restaurant_price_index, local_purchasing_power_index = local_purchasing_power_index, country_name = country_name, topography_id = topography_id, climate_type = climate_type, countries=countries, climates=climates, topographys=topographys)


    # Update city =============================================================
    @app.route('/updateCity', methods=['GET', 'POST'])
    def updateCity():
        city_id = str(request.form.get('city_id'))
    
        city_name = str(request.form.get('city_name'))
        cost_of_living_index = str(request.form.get('cost_of_living_index'))
        rent_index = str(request.form.get('rent_index'))
        general_cost_index = str(request.form.get('general_cost_index'))
        groceries_index = str(request.form.get('groceries_index'))
        restaurant_price_index = str(request.form.get('restaurant_price_index'))
        local_purchasing_power_index = str(request.form.get('local_purchasing_power_index'))
        country_name = str(request.form.get('country_name'))
        topography_id = str(request.form.get('topography_id'))
        climate_type = str(request.form.get('climate_type'))

        # Call update_city procedure
        sql = "CALL update_city('"+ city_id +"','"+ city_name +"', '"+ cost_of_living_index +"', '"+ rent_index +"', '"+ general_cost_index +"', '"+ groceries_index +"', '"+ restaurant_price_index +"', '"+ local_purchasing_power_index +"', '"+ country_name +"', '"+ topography_id +"', '"+ climate_type +"')"
        cityCursor.execute(sql)

        cityInfo = getCity(city_id)

        city_id = cityInfo[0]
        city_name = cityInfo[1]
        cost_of_living_index = cityInfo[2]
        rent_index = cityInfo[3]
        general_cost_index = cityInfo[4]
        groceries_index = cityInfo[5]
        restaurant_price_index = cityInfo[6]
        local_purchasing_power_index = cityInfo[7]
        country_name = cityInfo[8]
        topography_id = cityInfo[9]
        climate_type = cityInfo[10]

        countries = getCountries()
        climates = getClimates()
        topographys = getTopography()

        return render_template("profile.html", city_id = city_id, city_name = city_name, cost_of_living_index = cost_of_living_index, rent_index = rent_index, general_cost_index = general_cost_index, groceries_index = groceries_index,
        restaurant_price_index = restaurant_price_index, local_purchasing_power_index = local_purchasing_power_index, country_name = country_name, topography_id = topography_id, climate_type = climate_type, countries=countries, climates=climates, topographys=topographys)


    # Delete city =========================================================
    @app.route('/deleteCity', methods=['POST'])
    def deleteCity():
        city_id = str(request.form.get('city_id'))

        # Call delete_city procedure
        sql = "CALL delete_city('"+ city_id +"')"
        cityCursor.execute(sql)

        countries = getCountries()
        climates = getClimates()
        topographys = getTopography()

        return render_template('new.html', countries=countries, climates=climates, topographys=topographys)


    # Introduction page
    @app.route('/introduction')
    def introduction():
        return render_template('introduction.html')


    # Load the config file
    app.config.from_object('config')

except pymysql.Error as e:
    print('Error: %d: %s' % (e.args[0], e.args[1]))
