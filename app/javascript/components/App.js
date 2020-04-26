import React from 'react'
import Login from './Login'
import Register from './Register'
import { Link } from 'react-router';

class App extends React.Component {
  render () {
    return (
      <li><Link to="/react">Register</Link></li>
      <Login/>
    )
  }
}
export default App
