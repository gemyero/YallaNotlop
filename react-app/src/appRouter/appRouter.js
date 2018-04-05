import React from 'react';
import { BrowserRouter, Route, Switch } from "react-router-dom";
import Login from '../components/login';

const AppRouter =()=> (
    <BrowserRouter>
        <div>
            <Switch>
                <Route path="/login" component={Login}/>
            </Switch>
        </div>
    </BrowserRouter>
)

export default AppRouter;
