import React, { ReactFragment } from 'react';

export default class Friends extends React.Component {
  render() {
    return myFriends.map(friend => (
      <FriendProfile key={friend.id} name={friend.name} age={friend.age} />
    ))
  }
}

class FriendProfile extends React.Component {
  render() {
    return this.props.age != null ? this.props.name : null
  }
}

const myFriends = [
  {
    id: 1,
    name: 'Potatoes',
    age: '4 months'
  },
  {
    id: 2,
    name: 'Flower',
    age: '6 months'
  },
  {
    id: 3,
    name: 'Turtle'
  }
];

