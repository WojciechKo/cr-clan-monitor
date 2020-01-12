import axios from 'axios';

export default class ClanRepository {
  public fetch_clan(clanTag: any) {
    const url = `${process.env.VUE_APP_API_HOST}/clans/${clanTag}`;
    return axios.get(url);
  }
}
