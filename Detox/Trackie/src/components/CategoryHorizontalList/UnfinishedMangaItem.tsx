import React, {useCallback} from 'react';
import styled from 'styled-components/native';
import {RootState, useAppDispatch} from 'src/redux/AppStore';

import {ColorProps} from 'src/shared/Types';
import MangaCoverImage from 'src/components/MangaCoverImage';
import {useSelector} from 'react-redux';
import ProgressBar from 'src/components/ProgressBar';
import {RootChildScreenProp} from 'src/navigation/types';
import {getMangaThunk} from 'src/redux/actions/MangaActions';

export interface UnfinishedMangaItemProps {
  mangaId: number;
  navigation: RootChildScreenProp;
}

function UnfinishedMangaItem(props: UnfinishedMangaItemProps) {
  const {mangaId, navigation} = props;
  const dispatch = useAppDispatch();
  const theme = useSelector((state: RootState) => state.user.theme);
  const status = useSelector((state: RootState) => {
    const filtered = state.user.reading_statuses.filter(
      item => item.mangaId === mangaId && item.is_reading && !item.is_finished,
    );
    return filtered.length === 1 ? filtered[0] : null;
  });
  const manga = useSelector((state: RootState) => state.mangas.mangas[mangaId]);

  const onMangaPress = useCallback(() => {
    navigation.navigate('manga_detail', {
      mangaId,
    });
  }, [mangaId, navigation]);

  if (!manga) {
    dispatch(getMangaThunk(mangaId));
    return null;
  }
  if (!status || (manga && !manga.chapters)) {
    return null;
  }

  const progress = parseInt(
    ((status.last_read_page / manga.chapters!!) * 100).toFixed(0),
    10,
  );

  return (
    <Container onPress={onMangaPress}>
      <MangaCoverImage url={manga.img} />
      <Name numberOfLines={1} color={theme.onView}>
        {manga.title}
      </Name>
      <Name numberOfLines={1} color={theme.onViewFaint}>
        {`${status.last_read_page}/${manga.chapters}`}
      </Name>
      <ProgressBar
        targetProgress={progress}
        style={{
          outerColor: theme.primaryDark,
          progressColor: theme.primary,
        }}
      />
    </Container>
  );
}

const Container = styled.TouchableOpacity`
  width: 120px;
  margin: 4px;
  padding: 0 4px;
`;

const Name = styled.Text<ColorProps>`
  font-size: 15px;
  color: ${({color}) => color};
`;

export default UnfinishedMangaItem;
