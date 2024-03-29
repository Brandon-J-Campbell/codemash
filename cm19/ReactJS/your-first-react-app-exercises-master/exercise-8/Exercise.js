import React from 'react';

export default function Exercise() {
  return <Friends friends={myFriends} />
}

function Friends({friends}) {
  return (
    <Page>
      {friends.map(friend => (
        <FriendProfile 
          key={friend.id} 
          name={friend.name} 
          image={friend.image} />
      ))}
    </Page>
  );
}


function FriendProfile({name, image}) {
  return (
    <Card>
      <div className="friend-profile">
        <img src={image} alt={name} />
        <h3>{name}</h3>
      </div>
    </Card>
  );
}

function Card( { children } ) {
  return (
    <div class="card">{ children }</div>
  )
}

function Page( { children } ) {
  return (
  <div class="page">
    <dic class="content">
      { children }
    </dic>
  </div>
  )
}

const myFriends = [
  {
    id: 1,
    name: 'Potatoes',
    image: 'http://placekitten.com/150/150?image=1',
  },
  {
    id: 2,
    name: 'Flower',
    image: 'http://placekitten.com/150/150?image=12',
  },
  {
    id: 3,
    name: 'Turtle',
    image: 'http://placekitten.com/150/150?image=15',
  },
];
