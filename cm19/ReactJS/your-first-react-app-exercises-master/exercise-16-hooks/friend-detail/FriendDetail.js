import React from 'react';
import { Link } from 'react-router-dom';
import Page from '../shared/Page';
import Card from '../shared/Card';
import FriendFlipper from './FriendFlipper';

import styles from './FriendDetail.css';

function renderFriend(friend) {
  if (friend === undefined) {
    return <h1>Loading...</h1>;
  }
  
  return (
    <div className={styles.cardContents}>
      <h1>{friend.name}</h1>
      <FriendFlipper friend={friend} />
      <p>{friend.bio}</p>
    </div>
  );
}
export default function({ friend }) {
  return (
    <Page>
      <div className={styles.friendDetail}>
        <div className={styles.toolbar}>
          <Link to="/">&lt; Home</Link>
        </div>
        <Card>{renderFriend(friend)}</Card>
      </div>
    </Page>
  );
}
