import React, { Component } from 'react';
import logo from './logo.svg';
// import './App.css';
import Login from './components/login';
import { BrowserRouter as Router, Route, Link } from "react-router-dom";

class App extends Component {
  render() {
    return (
      <div classNAme="App">
      <Router>
      <div>
              <Route exact path="/Login" Component={Login} />
          </div>
      </Router>
      </div>
    );
  }
}

export default App;
