# Todo list for features

- extract all DB calls into class object so that we can eventually support other db libraries instead of only Sqlite3 like rails supports many.

- Move generators to use templates ( can access variables defined on class ? )

currently generating models/controllers are done in line using bad code practices I want to move to a template file that can be rendered cleanly.
